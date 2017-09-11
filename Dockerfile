FROM ruby:2.4.1

RUN apt-get update && apt-get install apt-transport-https \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y build-essential nodejs yarn --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /example-rails/
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME
RUN bundle install

COPY package.json yarn.lock $APP_HOME
RUN yarn install

RUN cp *.lock /tmp
COPY . $APP_HOME
RUN cp /tmp/*.lock .

COPY . $APP_HOME

EXPOSE 3000
ENTRYPOINT ["bundle", "exec", "rails"]
CMD ["server", "-b", "0.0.0.0", "-p", "3000"]
