FROM ruby:3.2.2

ENV RAILS_ENV production
ENV PROJECT_NAME fhba-mkt
WORKDIR /$PROJECT_NAME

RUN gem install bundler --no-document -v '2.4.10'
COPY Gemfile /$PROJECT_NAME/Gemfile
COPY Gemfile.lock /$PROJECT_NAME/Gemfile.lock
RUN bundle install
COPY . /fhba-mkt
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rake assets:precompile
CMD ["bundle","exec", "puma", "config.ru"]
