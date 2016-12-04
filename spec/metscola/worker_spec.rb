require 'spec_helper'

describe Metscola::Worker do
  context 'pc' do
    describe 'total_ms' do
      context '(30 + 10) / 2, (100 + 200) / 2, 200の時' do
        it '集計すること' do
          Metscola.summary_range = 60
          logs = [
            '2016-12-03T19:23:44+09:00	debug.test	{"messages":"Started HEAD \"/?p=9\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 30ms (Views: 22.4ms | ActiveRecord: 0.0ms)\n\n","debug":"INFO","h":"localhost","mt":"HEAD","pt":"/?p=9","ip":"::1","ua":"curl/7.43.0","rf":null}',
            '2016-12-03T19:23:44+09:00	debug.test	{"messages":"Started HEAD \"/?p=9\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 10ms (Views: 22.4ms | ActiveRecord: 0.0ms)\n\n","debug":"INFO","h":"localhost","mt":"HEAD","pt":"/?p=9","ip":"::1","ua":"curl/7.43.0","rf":null}',
            '2016-12-03T19:25:44+09:00	debug.test	{"messages":"Started GET \"/?p=11\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 100ms (Views: 10ms | ActiveRecord: 10.0ms)\n\n","debug":"INFO","h":"localhost","mt":"GET","pt":"/?p=11","ip":"::1","ua":"curl/7.43.0","rf":null}',
            '2016-12-03T19:25:45+09:00	debug.test	{"messages":"Started GET \"/?p=11\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 200ms (Views: 40ms | ActiveRecord: 40.0ms)\n\n","debug":"INFO","h":"localhost","mt":"GET","pt":"/?p=11","ip":"::1","ua":"curl/7.43.0","rf":null}',
            '2016-12-03T19:26:46+09:00	debug.test	{"messages":"Started GET \"/?p=11\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 200ms (Views: 40ms | ActiveRecord: 40.0ms)\n\n","debug":"INFO","h":"localhost","mt":"GET","pt":"/?p=11","ip":"::1","ua":"curl/7.43.0","rf":null}',
          ].join("\n")
          tempfile = Tempfile.new
          begin
            tempfile.write(logs) && tempfile.seek(0)
            worker = Metscola::Worker.new(tempfile.path, 0)
            worker.work!
            expect(worker.summary.list(:pc).map { |x| x.total_ms }).to eq(
              [20.0, 150.0, 200.0]
            )
          ensure
            tempfile.close
          end
        end
      end
    end
  end
end
