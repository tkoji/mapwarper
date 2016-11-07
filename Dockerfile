FROM ruby:2.3.1
ENV APP_ROOT /usr/src/mapwarper

WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get install -y \
        postgresql-9.4-postgis-2.1 \
        postgresql-server-dev-all \
        postgresql-contrib \
        build-essential \
        git-core \
        libxml2-dev \
        libxslt-dev \
        imagemagick \
        libmapserver1 \
        gdal-bin \
        libgdal-dev \
        ruby-mapscript \
        nodejs \
        --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  rm -rf ~/.gem

COPY . $APP_ROOT


EXPOSE  3000
CMD ["rails", "server", "-b", "0.0.0.0"]
