if defined? ActiveRecord::Base
  require File.join(File.dirname(__FILE__), 'acts_as_opengraph', 'active_record', 'acts', 'opengraph')
  ActiveRecord::Base.send :include, ActiveRecord::Acts::Opengraph
end

if defined? ActionView::Base
  require File.join(File.dirname(__FILE__), 'acts_as_opengraph', 'helper', 'acts_as_opengraph_helper')
  ActionView::Base.send :include, ActsAsOpengraphHelper
end

