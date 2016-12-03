# Metscola
* ログを集計します

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metscola'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metscola

## Usage
```ruby
metscola = Metscola.new(path: path)
metscola.import # blocking for process
metscola.list
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/metscola.

