---
layout: post
title: "When Slices Should be Iterators"
date: 2022-02-13 16:04:34 +0000
comments: true
categories:
- Rust
---

Today I had a bit of fun learning how to get more into the head-space on defining
better parameters in my rust functions when they work with a collection.  Let's
go on a journey and get to the final evolution of where I ended up and what was
learned.

<!-- more -->

First we'll need to start with a small snippet of code to get an idea of where
it started.  In this case I was tinkering with a simple cache store of a `RwLock`
around a `HashMap` where the values are insulated in an `Arc`.

```rust
use std::collections::HashMap;
use std::hash::Hash;
use std::sync::{Arc, RwLock};

pub struct Cache<K, V>(RwLock<HashMap<K, Arc<V>>>);

impl<K: Eq + Hash, V> Cache<K, V> {
    pub fn new() -> Self {
        Cache(RwLock::new(HashMap::new()))
    }

    pub fn store(&self, key: K, value: V) {
        self.0
            .write()
            .expect("A write lock to store cache item")
            .insert(key, Arc::new(value));
    }

    pub fn get(&self, key: &K) -> Option<Arc<V>> {
        self.0
            .read()
            .expect("A reading lock to read cache item")
            .get(key)
            .map(Arc::clone)
    }
}

#[cfg(test)]
mod test {
    use super::Cache;

    #[test]
    fn a_simple_read_and_write() {
        let cache = Cache::new();
        cache.store("test", "it");
        let fetched = cache.get(&"test").unwrap();
        assert_eq!(*fetched, "it");
        assert!(cache.get(&"junk").is_none());
    }
}
```

I then wanted to add a bulk fetch method which would utilize a single read lock
to bulk fetch as many cached items via keys.  My first pass ended up looking
like this:

```rust
// Inside impl for Cache<K, V>
pub fn get_for_keys(&self, keys: &[K]) -> Vec<Arc<V>> {
    let hash = self.0.read().expect("A reading lock to get for keys");

    keys.iter()
        .flat_map(|key| {
            hash.get(key)
                .map(Arc::clone)
        })
        .collect()
}


// Added to tests
#[test]
fn simple_get_for_keys() {
    let cache = Cache::new();
    cache.store('a', "apple");
    cache.store('b', "banana");
    cache.store('c', "crayon");

    let keys = vec!['a', 'b', 'z'];
    let hits = cache.get_for_keys(&keys);

    assert_eq!(hits.len(), 2);
    assert!(hits.contains(&Arc::new("apple")));
    assert!(hits.contains(&Arc::new("banana")));
}
```

Sweet, tests pass and we are in business!  Now lets plug it in roughly to the
code path I was hoping to use it in...

```rust
let cache = Cache::new();
cache.store('a', "apples");
cache.store('b', "bananas");

let mut keys = HashSet::new();
keys.insert('a');
keys.insert('b');
keys.insert('z');

let hits = cache.get_for_keys(&keys);
//                            ^^^^^ expected slice `[char]`, found struct `HashSet`
```

It turns out a slice won't work, so it's back to the drawling board.  I'm not
actually even using the slice directly really, I'm just using the iterator it
provides via `.iter()`.  So why not just require an iterator to begin with? Here
is what my next try looked like.

```rust
// Had to add an `'a` lifetime to the start of the impl:
impl<'a, K: Eq + Hash + 'a, V> Cache<K, V> {}

// Updated get_for_keys
pub fn get_for_keys<I>(&self, keys: I) -> Vec<Arc<V>>
where
    I: Iterator<Item = &'a K>
{
    let hash = self.0.read().expect("A reading lock to get for keys");

    keys.flat_map(|key| {
            hash.get(key)
                .map(Arc::clone)
        })
        .collect()
}

// Had to update test
#[test]
fn simple_get_for_keys() {
    let cache = Cache::new();
    cache.store('a', "apple");
    cache.store('b', "banana");
    cache.store('c', "crayon");

    let keys = vec!['a', 'b', 'z'];
    let hits = cache.get_for_keys((&keys).iter());

    assert_eq!(hits.len(), 2);
    assert!(hits.contains(&Arc::new("apple")));
    assert!(hits.contains(&Arc::new("banana")));
}
```

This works now for any iterator; however, I'm not a fan of the `(&keys).iter()`
that is needed now to get it to work for different collections that can produce
an iterator.  It turns out that there is also a trait that covers this as well,
and it's called `IntoIterator`.

```rust
// Updated get_for_keys
pub fn get_for_keys<I>(&self, keys: I) -> Vec<Arc<V>>
where
    I: IntoIterator<Item = &'a K>
{
    let hash = self.0.read().expect("A reading lock to get for keys");

    keys.into_iter()
        .flat_map(|key| {
            hash.get(key)
                .map(Arc::clone)
        })
        .collect()
}

// (&keys).iter() still works, but now so does this
#[test]
fn simple_get_for_keys() {
    let cache = Cache::new();
    cache.store('a', "apple");
    cache.store('b', "banana");
    cache.store('c', "crayon");

    let keys = vec!['a', 'b', 'z'];
    let hits = cache.get_for_keys(&keys);

    assert_eq!(hits.len(), 2);
    assert!(hits.contains(&Arc::new("apple")));
    assert!(hits.contains(&Arc::new("banana")));
}

// And this also works:
#[test]
fn get_for_keys_with_hashset() {
    let cache = Cache::new();
    cache.store('a', "apples");
    cache.store('b', "bananas");
    cache.store('c', "crayons");

    let mut keys = HashSet::new();
    keys.insert('a');
    keys.insert('b');
    keys.insert('z');

    let hits = cache.get_for_keys(&keys);
    assert_eq!(hits.len(), 2);
    assert!(hits.contains(&Arc::new("apples")));
    assert!(hits.contains(&Arc::new("bananas")));
}
```

This lets you use a reference to any collection which implements `IntoIterator`.
I'm pretty happy with what was learned while tinkering with this caching idea.
Can't say if the whole thing in total is worth anything, but this little bit of
insight gained is a big one.  When first starting with rust it felt like I was
wanting to work with slices; however, more often then not what's being called
for is an iterator.  If you find yourself in the same spot then hopefully this
has opened your eyes!
