require 'spec_helper'

describe Metscola do
  it 'has a version number' do
    expect(Metscola::VERSION).not_to be nil
  end

  describe '.run' do
    context 'when using シーケンシャル' do
      it 'return instance of Result' do
        begin
          tempfile = Tempfile.new
          log = '2016-12-03T19:25:44+09:00	debug.test	{"messages":"Started GET \"/?p=11\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 100ms (Views: 10ms | ActiveRecord: 10.0ms)\n\n","debug":"INFO","h":"localhost","mt":"GET","pt":"/?p=11","ip":"::1","ua":"curl/7.43.0","rf":null}'
          tempfile.write(log) && tempfile.seek(0)
          path = Metscola.run(tempfile.path)
          expect(path).to be_a(String)
        ensure
          tempfile.close
        end
      end
    end
    context 'when using concurency' do
      it 'return instance of Result' do
        begin
          tempfile = Tempfile.new
          log = '2016-12-03T19:25:44+09:00	debug.test	{"messages":"Started GET \"/?p=11\" for ::1 at 2016-12-03 19:23:44 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"9\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (3.2ms)\nCompleted 200 OK in 100ms (Views: 10ms | ActiveRecord: 10.0ms)\n\n","debug":"INFO","h":"localhost","mt":"GET","pt":"/?p=11","ip":"::1","ua":"curl/7.43.0","rf":null}'
          tempfile.write(log) && tempfile.seek(0)
          paths = Metscola.run([tempfile.path])
          expect(paths).to be_a(Array)
        ensure
          tempfile.close
        end
      end
    end
  end
end
