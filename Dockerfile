FROM ruby:2.5.3-alpine
RUN apk upgrade --no-cache \
      &&  apk add --no-cache build-base \
      libc-dev linux-headers tzdata \
      libxml2-dev \
      libxslt-dev nodejs git sqlite sqlite-dev sqlite-libs
RUN mkdir /swagger
WORKDIR /swagger
COPY Gemfile /swagger/Gemfile
COPY Gemfile.lock /swagger/Gemfile.lock
RUN bundle install
COPY . /swagger
