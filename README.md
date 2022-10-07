# Thin Air Labs Take Home Challenge

## Setup
1. Install [ASDF](https://asdf-vm.com/) to manage your Ruby installation
2. Run `asdf install` to install all required versions
3. Run `bundle install` to install required Ruby dependencies

*NOTE:* If you'd rather use `rbenv` or `rvm`, no problem, just ensure you install whatever
version of Ruby is listed in the `.tool-versions` file and the `Gemfile.lock`!

## Running
While building a front-end was out of scope for this particular project, you can run the code interactively
to test out the functionality. Once you have the correct version of Ruby installed, along with the Gemfile
dependencies, navigate to the root of the project, and open up your preferred Ruby interpreter. I like [Pry](https://pry.github.io/),
but `irb` will work just as well. From the prompt, run the following command:
```ruby
require_relative "discount_calculator"
```
Once the project is loaded, you can call `DiscountCalculator.new(order)` to instantiate the calculator class,
and then call `#calculate` on the resulting object to find the discounted price of the provided order.
The calculator expects the order to be passed in a specific format. The order should be passed as a hash, where
the keys correspond to distinct items the store offers, and the value represents the quantity of the item.
It should look something like this:
```ruby
{ item_1: 2, item_2: 3, item_3: 1}
```

## Testing
This project is set up with [RSpec](https://rspec.info/) for testing. To run the test file, run
```bash
bundle exec rspec
```
The repo is also set up with Github Actions to run the test suite every time a new commit is pushed.

## Linting & Formatting
This project uses [StandardRB](https://github.com/testdouble/standard) for both code linting and formatting.
To run the linter, run
```bash
bundle exec standardrb
```
To autoformat the entire project, run
```bash
bundle exec standardrb --fix
```
