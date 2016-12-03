# Metscola
* ログを集計する
* 引数には、分割されたログファイルを引数にする
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
metscola = Metscola.new(paths)
metscola.import! # blocking for process
metscola.list
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/metscola.

# メモ
* 1ファイルごとにmasterプロセスを起動して、複数ワーカーで集計をする
  * 引数ごとのファイル毎にmasterプロセスが起動する
