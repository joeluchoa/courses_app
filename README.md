# Courses App (Ruby on Rails)

A simple course management application built with Ruby on Rails.

## Project Summary

This project is a web application created using the Ruby on Rails framework. It provides a basic system for managing courses, students and attendance to the classes.

The application follows Rails conventions, utilizing a PostgreSQL database for data persistence and ERB (Embedded Ruby) for templating the views. It is an excellent example for developers looking to understand the fundamentals of a Model-View-Controller (MVC) architecture within the Rails ecosystem and to practice basic CRUD (Create, Read, Update, Delete) operations.

## Getting Started (Developer Setup)

These instructions will guide you through setting up a local development environment for this project on a fresh Linux or macOS system.

### Prerequisites

Before you begin, you will need `git` and a Ruby version manager (`rbenv` is recommended). You will also need a package manager (`apt` for Debian/Ubuntu, `Homebrew` for macOS) and the PostgreSQL database system.

---

### Setup for Linux (Debian/Ubuntu)

1.  **Update System and Install Dependencies:**
    Open your terminal and run the following commands to get essential packages.
    ```bash
    sudo apt update
    sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev
    ```

2.  **Install rbenv and ruby-build:**
    This will allow you to manage multiple Ruby versions easily.
    ```bash
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
    ```
    Next, add `rbenv` to your shell configuration to load it automatically.
    ```bash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    source ~/.bashrc
    ```

3.  **Install Ruby:**
    The project's `.ruby-version` file specifies the required Ruby version. Install it using `rbenv`.
    ```bash
    # From the project's root directory after cloning, rbenv can read the version file
    # Or you can specify it manually. Let's assume you've cloned it first.
    # git clone https://github.com/joeluchoa/courses_app.git
    # cd courses_app
    rbenv install $(cat .ruby-version)
    ```

4.  **Install PostgreSQL:**
    Rails requires a JavaScript runtime and a database.
    ```bash
    sudo apt install -y postgresql postgresql-contrib libpq-dev
    # Start and enable the PostgreSQL service
    sudo systemctl start postgresql
    sudo systemctl enable postgresql
    ```
    You may need to create a database user. By default, you can use the `postgres` user.
    ```bash
    sudo -u postgres createuser --interactive
    ```
    Enter your Linux username when prompted and answer 'y' to make it a superuser.

---

### Setup for macOS

1.  **Install Homebrew:**
    If you don't have it, Homebrew is the essential package manager for macOS.
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

2.  **Install Git, rbenv, and PostgreSQL:**
    Use Homebrew to install everything you need.
    ```bash
    brew install git rbenv ruby-build postgresql
    ```

3.  **Initialize rbenv:**
    Add `rbenv` to your shell configuration (for Zsh, which is default on modern macOS).
    ```bash
    echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.zshrc
    source ~/.zshrc
    ```

4.  **Install Ruby:**
    Install the Ruby version specified in the project's `.ruby-version` file.
    ```bash
    # Clone the repo first to make this easier
    # git clone https://github.com/joeluchoa/courses_app.git
    # cd courses_app
    rbenv install $(cat .ruby-version)
    ```

5.  **Start PostgreSQL Service:**
    Homebrew makes this simple.
    ```bash
    brew services start postgresql
    ```

---

### Final Project Installation (Both OS)

Once the prerequisites for your OS are installed, follow these steps inside your terminal.

1.  **Clone the Repository:**
    If you haven't already, clone the project to your local machine.
    ```bash
    git clone https://github.com/joeluchoa/courses_app.git
    cd courses_app
    ```

2.  **Set Local Ruby Version:**
    Tell `rbenv` to use the correct Ruby version for this project directory.
    ```bash
    rbenv local $(cat .ruby-version)
    ```

3.  **Install Bundler:**
    Bundler is the package manager for Ruby gems.
    ```bash
    # The --no-document flag speeds up installation by skipping documentation
    gem install bundler --no-document
    ```

4.  **Install Project Gems:**
    Bundler will read the `Gemfile` and install all required project dependencies.
    ```bash
    bundle install
    ```

5.  **Create and Set Up the Database:**
    This command will create the development and test databases and run any existing migrations to set up the schema.
    ```bash
    rails db:setup
    ```

6.  **Run the Development Server:**
    Start the local Rails server.
    ```bash
    rails server
    ```
    You should see output indicating the server is running, typically on port 3000.

7.  **Access the Application:**
    Open your web browser and navigate to `http://localhost:3000`. You should now see the Courses App home page.
