#FROM ruby:2.6.3-alpine3.9
FROM ruby:2.5.1-alpine

# App variables
ENV APP_PATH /smapi/
ENV APP_USER smapi
ENV APP_USER_HOME /home/smapi
# Bundler variables
ENV BUNDLE_PATH $APP_USER_HOME
ENV GEM_HOME $APP_USER_HOME/bundle
ENV BUNDLE_BIN $GEM_HOME/bin
# Rails variables
ENV RAILS_LOG_TO_STDOUT=true
# System variables
ENV PATH $PATH:$BUNDLE_BIN
# Timezone
ENV TZ=America/Sao_Paulo

# Puma
EXPOSE 3000

# UID of the user that will be created
ARG UID

# Validating if UID argument was provided
RUN : "${UID:?You must provide a UID argument when building this image.}"

# Creating an user so we don't run everything as root
RUN adduser -h $APP_USER_HOME -D -u $UID $APP_USER

# cd to $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile* $APP_PATH

# Installing packages, gems and node modules
RUN apk update && \
    apk add --no-cache build-base curl postgresql-dev tzdata git freetds-dev autoconf pkgconfig automake libtool nasm zlib-dev

# RUN bundle install

RUN chown -R $APP_USER:$APP_USER $APP_USER_HOME && \
    chown -R $APP_USER:$APP_USER $APP_PATH

RUN apk del build-base curl autoconf pkgconfig automake libtool nasm zlib-dev && \
    rm -r /var/cache/apk/*

COPY --chown=smapi . $APP_PATH

USER $APP_USER
