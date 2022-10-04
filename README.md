# Thin Air Labs Take Home Challenge

## Setup
1. Install [ASDF](https://asdf-vm.com/) to manage your Ruby installation
2. Run `asdf install` to install all required versions
3. Run `bundle install` to install required Ruby dependencies

## Testing
This project is set up with [RSpec](https://rspec.info/) for testing. To run the test file, run
```bash
$ bundle exec rspec
```

## Linting & Formatting
This project uses [StandardRB](https://github.com/testdouble/standard) for both code linting and formatting.
To run the linter, run
```bash
$ bundle exec standardrb
```
To autoformat the entire project, run
```bash
$ bundle exec standardrb --fix
```
