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
# log sample
# 2016-12-03T19:23:44+09:00	debug.test	{"messages":"Started HEAD \"/?p=3\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"3\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (2.9ms)\nCompleted 200 OK in 37ms (Views: 19.4ms | ActiveRecord: 0.0ms)\n\n","debug":"INFO","h":"localhost","mt":"HEAD","pt":"/?p=3","ip":"::1","ua":"curl/7.43.0","rf":null}
paths = %w[
  20160301_1.log
  20160301_2.log
  20160301_3.log
]
Metscola.targets << { name: :popular_log,
  values: {
    total_ms: :integer,
    mss: :integer,
    time: :date,
    user_agent: :sring,
    method: :string,
    path: :string,
  },
  unique_keys: [:path, :method],
  parser: ->(log) {
    log =~ /in ([\d.]+)ms \(/
    @total_ms = $1.to_f
    /([\d:T-]+)\+09:00\t+([\w.]+)\t+({.*})/o =~ log
    json = JSON.parse($3)
    @time = Time.parse($1)
    @mss = json['messages'].scan(/(\w+): ([\d.]+)ms/o).
      inject({}) { |a, v| a[v.first.to_sym] = v.last.to_f; a }
    @method = json['mt'].to_sym
    @user_agent = json['ua']
    @path = json['pt']
  }
}
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
