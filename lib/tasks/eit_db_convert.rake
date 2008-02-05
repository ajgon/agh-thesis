require "#{RAILS_ROOT}/config/environment.rb"

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

class OriginalBase < ActiveRecord::Base
end
class ConvertedBase < ActiveRecord::Base
end

namespace :eit do
  namespace :db do
    desc 'Converts data from old database to new one'
    task :convert => :environment do
      puts File.join(File.dirname(__FILE__), '..', '..', 'config', 'boot')
      OriginalBase.establish_connection(ActiveRecord::Base.configurations['original'])
      ConvertedBase.establish_connection(ActiveRecord::Base.configurations['converted'])
    end
  end
end