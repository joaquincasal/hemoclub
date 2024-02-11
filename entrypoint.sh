#!/bin/sh

bundle exec rails db:migrate
bundle exec puma config.ru
