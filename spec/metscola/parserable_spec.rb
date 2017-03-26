require 'spec_helper'

describe Metscola::Parserable do
  let(:tmp_class) do
    Struct.new(:unused_attrs) do
      include Metscola::Parserable
    end
  end
  describe 'parser' do
    context 'messages が 配列の時' do
      it 'be success' do
        log = "2017-03-22T00:00:00+09:00\tdebug.test\t{\"sid\":\"2\",\"uid\":\"\",\"dev\":\"s\",\"messages\":[\"Started GET \\\"/f\\\" for 122.196.240.213 at 2017-03-22 00:00:00 +0900\",\"Processing by FsController#index as HTML\",\"  Parameters: {\\\"a\\\"=>[\\\"206\\\"], \\\"p\\\"=>[\\\"27\\\"], \\\"tags\\\"=>[\\\"学\\\"]}\",\"Completed 200 OK in 218ms (Views: 46.1ms | ActiveRecord: 106.2ms | Solr: 8.3ms)\"],\"level\":\"INFO\",\"mt\":\"GET\",\"pt\":\"/f?are\",\"ip\":\"888.888.888.888\",\"ua\":\"Mo37.36\",\"rf\":\"http://google.com\"}\n"
        parser = tmp_class.new(log)
        expect(parser.mss).to eq({
          Views: 46.1, ActiveRecord: 106.2, Solr: 8.3
        })
        expect(parser.total_ms).to eq(218.0)
        expect(parser.path).to eq('/f?are')
        expect(parser.time).to eq(Time.parse('2017-03-22 00:00:00 +0900'))
      end
    end
    context 'レスポンスタイムに小数点がある時' do
      it 'be success' do
        log = '2016-12-03T19:23:44+09:00	debug.test	{"messages":"Started HEAD \"/?p=9\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 41ms (Views: 22.4ms | ActiveRecord: 0.0ms)\n\n","debug":"INFO","h":"localhost","mt":"HEAD","pt":"/?p=9","ip":"::1","ua":"curl/7.43.0","rf":null}'
        parser = tmp_class.new(log)
        expect(parser.mss).to eq({
          Views: 22.4, ActiveRecord: 0.0
        })
        expect(parser.total_ms).to eq(41.0)
        expect(parser.path).to eq('/?p=9')
        expect(parser.time).to eq(Time.parse('2016-12-03 19:23:44 +0900'))
      end
    end

    context 'レスポンスタイムに小数点がない時' do
      it 'be success' do
        log = '2016-12-03T19:23:44+09:00	debug.test	{"messages":"Started GET \"/?p=11\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 200ms (Views: 40ms | ActiveRecord: 40.0ms)\n\n","debug":"INFO","h":"localhost","mt":"GET","pt":"/?p=11","ip":"::1","ua":"curl/7.43.0","rf":null}'
        parser = tmp_class.new(log)
        expect(parser.total_ms).to eq(200)
      end
    end
  end
end
