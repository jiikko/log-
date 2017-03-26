# Metscola
* PC/SPとpath毎にレスポンスタイムの平均を出す

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metscola'
```
```
# for ruby-filemagic
* Debian/Ubuntu
  * libmagic-dev
* OS X
  * brew install libmagic
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metscola

## Usage
```ruby
paths = %w[
  20160301_1.log
  20160301_2.log
  20160301_3.log
]
files = Metscola.run(paths)
file = Metscola.run('./spec/files/sample.log')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/metscola.

# TODO
* 分散モード
  * druby?
  * s3から落として集計結果を取得する
* s3からダウンロード
