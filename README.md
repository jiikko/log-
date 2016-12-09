# Metscola
* ログは時系列にソート済みであること
* 小規模システムのログを集計する
* 引数には、分割されたログファイルをとる
  * エディタでオープンに時間がかかるし大抵の環境だと分割されているので

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
paths = %w[
  20160301_1.log
  20160301_2.log
  20160301_3.log
]
files = Metscola.new(paths).work
file = Metscola.new('./spec/files/sample.log').work
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/metscola.

# TODO
* 分散モード
  * druby?
  * s3から落として集計結果を取得する
* 圧縮ファイルを引数にとれり
* s3からダウンロード
