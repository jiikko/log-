require 'spec_helper'

describe Metscola::Parser do
  describe 'parser' do
    it 'be success' do
      log = '2016-11-28T22:33:31+09:00	debug_test	{"messages":"Started HEAD \"/?p=4\" for ::1 at 2016-11-28 22:33:31 +0900\nProcessing by Rails::WelcomeController#index as */*\n  Parameters: {\"p\"=>\"4\", \"internal\"=>true}\n  Rendering /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb\n  Rendered /Users/koji/.rvm/gems/ruby-2.3.1/gems/railties-5.0.0.1/lib/rails/templates/rails/welcome/index.html.erb (2.9ms)\nCompleted 200 OK in 44ms (Views: 25.1ms | ActiveRecord: 0.0ms)\n\n","debug":"INFO","ip":"::1","ua":"curl/7.43.0"}'
      parser = Metscola::Parser.new(log)
      expect(parser.event).to eq 'debug.test'
    end
  end
end
