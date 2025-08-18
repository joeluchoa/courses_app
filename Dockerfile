# Dockerfile

# Use a specific, slim version of the official Ruby image for reproducibility
FROM ruby:3.1.2-slim-bullseye

# Set environment variables for production
ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="1"

# Install essential OS-level dependencies
# - build-essential: For compiling gems
# - libvips: For Active Storage image processing
# - curl: For general networking
# - postgresql-client: To allow the app to connect to the PG database
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libvips \
    curl \
    postgresql-client

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock first to leverage Docker's layer caching.
# If these files don't change, the 'bundle install' step won't run again.
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs 20 --retry 5

# Copy the rest of your application code into the container.
# This respects the .dockerignore file.
COPY . .

# Precompile assets for production.
# The RAILS_MASTER_KEY is needed if your credentials are used during precompilation.
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# This is the command that will run when the container starts.
# It launches the Rails server on all IPs (0.0.0.0) on port 3000.
CMD ["bundle", "exec", "rails", "server"]
