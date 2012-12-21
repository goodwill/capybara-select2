# Capybara::Select2

All this gem does is something very simple- allow you to trigger select2 dropdown to select the value you want. The original select doesn't with the javascript overrides, so this new helper method does only this thing.

## Installation

Add this line to your application's Gemfile:

    gem 'capybara-select2', group: :test

Or, add it into your test group

	group :test do
		gem 'capybara-select2'
		...
	end	

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-select2

The gem automatically hook itself into rspec helper using Rspec.configure.

## Usage

Just use this method inside your capybara test:
	select2("Dropdown Text", from: "Label of the dropdown")

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
