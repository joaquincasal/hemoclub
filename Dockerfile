FROM ruby:3.2.2
RUN apt update -qq
RUN curl -sLo https://deb.nodesource.com/setup_18.18.0 | bash
RUN apt install -y nodejs npm
RUN npm install -g yarn

ENV PROJECT_NAME placeholder
WORKDIR /$PROJECT_NAME

RUN gem install bundler --no-document -v '2.4.10'
COPY Gemfile /$PROJECT_NAME/Gemfile
COPY Gemfile.lock /$PROJECT_NAME/Gemfile.lock
RUN bundle install
COPY . /placeholder
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile
CMD ["bundle","exec", "puma", "config.ru"]
