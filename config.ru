require 'rubygems'
require 'gollum/app'
require 'settingslogic'

gollum_path = '.'

# This is the key to make Gollum work on Heroku
unless File.exists? '.git'
    repo = Grit::Repo.init(gollum_path)
    repo.add('.')
    repo.commit_all('Create gollum wiki')
end

module Precious
    class App < Sinatra::Base
        use Rack::Auth::Basic, "Restricted Area" do |username, password|
            [username, password] == [Settings.username, Settings.password]
        end
    end
end


Precious::App.set(:default_markup, :markdown)
Precious::App.set(:wiki_options, { universal_toc: false, live_preview: true })
Precious::App.set(:gollum_path, gollum_path)
run Precious::App

