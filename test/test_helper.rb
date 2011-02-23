plugin_path = File.join File.dirname(__FILE__), '..'

require 'test/unit'

require 'rubygems'
require 'active_record'
require 'action_view'



ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
$stdout = StringIO.new

def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    
    create_table :books, :force => true do |t|
      t.string :title
    end
    
    create_table :movies, :force => true do |t|
      t.string :title
      t.string :description
      t.string :imdb
    end
    
    create_table :songs, :force => true do |t|
      t.string :title
    end
    
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

setup_db


$:.unshift File.join plugin_path, 'lib'

require 'acts_as_opengraph/active_record/acts/opengraph'
require 'acts_as_opengraph/helper/acts_as_opengraph_helper'
require 'acts_as_opengraph'