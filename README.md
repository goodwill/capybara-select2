# Capybara::Select2

[![Code Climate](https://codeclimate.com/github/goodwill/capybara-select2.png)](https://codeclimate.com/github/goodwill/capybara-select2)

All this gem does is something very simple- allow you to trigger select2 dropdown to select the value you want. The original select doesn't with the javascript overrides, so this new helper method does only this thing.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'capybara-select2', group: :test
```

Or, add it into your test group

``` ruby
group :test do
  gem 'capybara-select2'
  ...
end
```

And then execute:

``` bash
$ bundle
```

Or install it yourself as:

``` bash
$ gem install capybara-select2
```

The gem automatically hook itself into rspec helper using Rspec.configure.

If you're using capybara outside of Rspec, you may have to include the following (eg: in `features/support/env.rb` for Cucumber users):

``` ruby
include Capybara::Select2
```

## Usage

Just use this method inside your capybara test:

``` ruby
select2("Dropdown Text", from: "Label of the dropdown")
```

or

``` ruby
select2("Dropdown Text", xpath: "<xpath of the dropdown>")
```

If the select2 field has a `min_length` option (acts as a search field) specify it with:

``` ruby
select2("foo", from: "Label of the dropdown", search: true)
```

If select2 field has [tags](http://ivaynberg.github.io/select2/#tags) option you can use:

```ruby
select2_tag('value', from: 'Label of input')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
