# Giphy RSpec Test — Setup & Run

## Prerequisites
- Ruby 3.4.5
- Bundler (`gem install bundler`)

## Setup
1. Clone or open the repository:
    ```bash
    git clone <repo-url> && cd Giphy-Rspec-test
    ```

2. Install gems:
    ```bash
    bundle install
    ```

3. Configure environment variables:
    ```bash
    export GIPHY_API_KEY="your_giphy_api_key"
    ```
    Replace with a valid key

## Run tests
- Run the full test suite:
  ```bash
  bundle exec rspec
  ```

- Run with readable output:
  ```bash
  bundle exec rspec --format documentation
  ```