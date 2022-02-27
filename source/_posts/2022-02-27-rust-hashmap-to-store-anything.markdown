---
layout: post
title: "Rust HashMap to Store Anything"
date: 2022-02-27 15:31:11 +0000
comments: true
categories: 
- Rust
---

I came across the `Any` trait this week and it got me to thinking on how it
could be used to stored different kinds of data at runtime.  In this post
we'll look at this magical trait and get a better understanding of whats
possible.

<!-- more -->

## What is the Any Trait

> `Any` itself can be used to get a `TypeId`, and has more features when used as
> a trait object. As `&dyn Any` (a borrowed trait object), it has the `is` and
> `downcast_ref` methods, to test if the contained value is of a given type,
> and to get a reference to the inner value as a type. As `&mut dyn Any`,
> there is also the `downcast_mut` method, for getting a mutable reference to
> the inner value. `Box<dyn Any>` adds the downcast method, which attempts to
> convert to a `Box<T>`. See the Box documentation for the full details.

So what does that mean?  Essentially code such as the following is possible:

```rust
use std::any::Any;

pub struct Foo{}

pub fn is_a_foo(maybe_foo: &dyn Any) -> bool {
  maybe_foo.is::<Foo>()
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn is_a_foo_works() {
        let foo = Foo{};

        assert!(is_a_foo(&foo));
        assert!(!is_a_foo(&42));
    }
}
```

If you check out the `is` function under the hood what it's really doing is the
following:

```rust
pub fn is<T: Any>(&self) -> bool {
    // Get `TypeId` of the type this function is instantiated with.
    let t = TypeId::of::<T>();

    // Get `TypeId` of the type in the trait object (`self`).
    let concrete = self.type_id();

    // Compare both `TypeId`s on equality.
    t == concrete
}
```

The `TypeId` appears to be the real star of the show, and if you look into it a
bit more you'll find that not only can it be compared for equality; it can also
be hashed!

## The HashMap to Store Any Data

```rust
//
// rustc 1.60.0-nightly (b17226fcc 2022-02-18)
//
#![feature(box_into_inner)]

use std::any::{Any, TypeId};
use std::cmp::Eq;
use std::collections::HashMap;
use std::hash::Hash;

type HashKey<K> = (K, TypeId);
type Anything = Box<dyn Any>;

pub struct AnyMap<K: Eq + Hash>(HashMap<HashKey<K>, Anything>);

impl<K: Eq + Hash> AnyMap<K> {
    /// Creates a new hashmap that can store
    /// any data which can be tagged with the
    /// `Any` trait.
    pub fn new() -> Self {
        Self(HashMap::new())
    }

    /// Creates a new hashmap that can store
    /// at least the capacity given.
    pub fn new_with_capacity(capacity: usize) -> Self {
        Self(HashMap::with_capacity(capacity))
    }

    /// Inserts the provided value under the key.  Keys
    /// are tracked with their type; meaning you can
    /// have the same key used multiple times with different
    /// values.
    ///
    /// If the storage had a value of the type being stored
    /// under the same key it is returned.
    pub fn insert<V: Any>(&mut self, key: K, val: V) -> Option<V> {
        let boxed = self
            .0
            .insert((key, val.type_id()), Box::new(val))?
            .downcast::<V>()
            .ok()?;

        Some(Box::into_inner(boxed))
    }

    /// Fetch a reference for the type given under a
    /// given key.  Note that the key needs to be provided
    /// with ownership.  This may change in the future if
    /// I can figure out how to only borrow the key for
    /// comparison.
    pub fn get<V: Any>(&self, key: K) -> Option<&V> {
        self.0.get(&(key, TypeId::of::<V>()))?.downcast_ref::<V>()
    }

    /// A mutable reference for the type given under
    /// a given key.  Note that the key needs to be provided
    /// with ownership.
    pub fn get_mut<V: Any>(&mut self, key: K) -> Option<&mut V> {
        self.0
            .get_mut(&(key, TypeId::of::<V>()))?
            .downcast_mut::<V>()
    }

    /// Removes the data of the given type under they key
    /// if it's found.  The data found is returned in an
    /// Option after it's removed.
    pub fn remove<V: Any>(&mut self, key: K) -> Option<V> {
        let boxed = self
            .0
            .remove(&(key, TypeId::of::<V>()))?
            .downcast::<V>()
            .ok()?;

        Some(Box::into_inner(boxed))
    }
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn you_can_add_different_types_and_work_with_them() {
        let mut storage = AnyMap::new();
        storage.insert("pie", 3.142);
        storage.insert("pie", "apple");

        assert_eq!(
            &3.142,
            storage.get::<f64>("pie").unwrap()
        );

        assert_eq!(
            &"apple",
            storage.get::<&str>("pie").unwrap()
        );

        *storage.get_mut("pie").unwrap() = 3.14159;

        assert_eq!(
            &3.14159,
            storage.get::<f64>("pie").unwrap()
        );

        assert_eq!(
            None,
            storage.get::<f32>("pie")
        );

        assert_eq!(
            3.14159,
            storage.remove::<f64>("pie").unwrap()
        );

        assert_eq!(
            None,
            storage.get::<f64>("pie")
        );
    }
}
```
