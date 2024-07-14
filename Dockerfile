FROM ruby:3.0
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
EXPOSE 9292
CMD ["rackup", "--host", "0.0.0.0", "--port", "9292"]