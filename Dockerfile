# > Long have I been dormant, my return is at hand

# Trying to get my blog to build in current ruby is fairly
# impossible.  Instead just going to lean in on docker to
# be able to get my pages built and pushed up.

# last version of ruby I used, from the boat times...
FROM ruby:2.0

ENV LANG C.UTF-8

# Just a place to work from and bundle the Gemfile
# so I don't need to do it every time I run a container
WORKDIR /blog
COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN apt update
RUN apt-get install rsync -y

# ****** all commands assume in blog directory ******

# Setup the Image:
#
# docker build -t blog .
#

# Run shell from inside container:
#
# docker run -it --rm -v $PWD:/blog blog /bin/bash
#

# Make a post:
#
# docker run -it --rm -v $PWD:/blog blog rake new_post["Some Title"]
#

# Watch for changes and preview them:
#
# docker run -it --rm -p 4000:4000 -v $PWD:/blog blog rake preview
#

# Deploy site to the world-wide-web
#
# docker run -it --rm -v $HOME/.ssh:/root/.ssh -v $PWD:/blog blog rake rsync
#
