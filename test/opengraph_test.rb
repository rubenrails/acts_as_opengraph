require File.join File.dirname(__FILE__), 'test_helper'

class Book < ActiveRecord::Base
  acts_as_opengraph 
end

class Movie < ActiveRecord::Base
  acts_as_opengraph :values => {:type => "movie", :site_name => "IMDb"}, :columns => {:url => :imdb}
  
  def opengraph_image
    "http://ia.media-imdb.com/rock.jpg"
  end
  
end

class Song < ActiveRecord::Base
  # This model doesn't uses acts_as_opengraph
end

class MovieTest < Test::Unit::TestCase
  
  include ActsAsOpengraphHelper
  
  MOVIE_NAME = "The Rock"
  MOVIE_DESCRIPTION = "A renegade general and his group of U.S. Marines take over Alcatraz and threaten San Francisco Bay with biological weapons."
  MOVIE_URL = "http://www.imdb.com/title/tt0117500/"
  MOVIE_IMAGE = "http://ia.media-imdb.com/rock.jpg"
  
  GENERATED_OPENGRAPH_DATA = [
    {:value=> MOVIE_NAME, :name=> "og:title"}, 
    {:value=> "movie", :name=> "og:type"}, 
    {:value=> MOVIE_IMAGE, :name=> "og:image"}, 
    {:value=> MOVIE_URL, :name=> "og:url"}, 
    {:value=> MOVIE_DESCRIPTION, :name=> "og:description"}, 
    {:value=> "IMDb", :name=> "og:site_name"}
  ]
  
  GENERATED_META_TAGS = %(<meta property="og:title" content="#{MOVIE_NAME}"/>
<meta property="og:type" content="movie"/>
<meta property="og:image" content="#{Rack::Utils.escape_html(MOVIE_IMAGE)}"/>
<meta property="og:url" content="#{Rack::Utils.escape_html(MOVIE_URL)}"/>
<meta property="og:description" content="#{Rack::Utils.escape_html(MOVIE_DESCRIPTION)}"/>
<meta property="og:site_name" content="IMDb"/>)

  GENERATED_LIKE_BUTTON = %(<iframe src="http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.imdb.com%2Ftitle%2Ftt0117500%2F&amp;layout=standard&amp;show_faces=false&amp;width=450&amp;action=like&amp;colorscheme=light&amp;height=35" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:450px; height:35px;" allowTransparency="true"></iframe>)
  GENERATED_LIKE_BUTTON_CUSTOM_URL = %(<iframe src="http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fexample.com%2Fmovies%2F6&amp;layout=standard&amp;show_faces=false&amp;width=450&amp;action=like&amp;colorscheme=light&amp;height=35" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:450px; height:35px;" allowTransparency="true"></iframe>)
  GENERATED_LIKE_BUTTON_FBXML = %(<fb:like href=\"http%3A%2F%2Fwww.imdb.com%2Ftitle%2Ftt0117500%2F\" layout=\"standard\" show_faces=\"false\" action=\"like\" colorscheme=\"light\" width=\"450\" height=\"35\" font=\"\"></fb:like>)
  def setup
    setup_db
    assert @movie = Movie.create!(:title => MOVIE_NAME, :description => MOVIE_DESCRIPTION, :imdb => MOVIE_URL)
    assert @song = Song.create!(:title => "Yellow Submarine")
    assert @book = Book.create!(:title => "Getting real")
  end
  
  def teardown
    teardown_db
  end

  def test_respond_to_opengraph_methods
    assert_respond_to @movie, :opengraph_title
    assert_respond_to @movie, :opengraph_type
    assert_respond_to @movie, :opengraph_image
    assert_respond_to @movie, :opengraph_url
    assert_respond_to @movie, :opengraph_description
    assert_respond_to @movie, :opengraph_site_name
    assert_respond_to @movie, :opengraph_latitude
    assert_respond_to @movie, :opengraph_longitude
    assert_respond_to @movie, :opengraph_street_address
    assert_respond_to @movie, :opengraph_locality
    assert_respond_to @movie, :opengraph_region
    assert_respond_to @movie, :opengraph_postal_code
    assert_respond_to @movie, :opengraph_country_name
    assert_respond_to @movie, :opengraph_email
    assert_respond_to @movie, :opengraph_phone_number
    assert_respond_to @movie, :opengraph_fax_number
    assert_respond_to @movie, :opengraph_data
  end
  
  def test_opengraph_data
    assert_equal GENERATED_OPENGRAPH_DATA, @movie.opengraph_data
  end
  
  def test_default_values
    assert_equal "IMDb", @movie.opengraph_site_name
  end
  
  def test_method_overriding
    assert_equal "http://ia.media-imdb.com/rock.jpg", @movie.opengraph_image
  end
  
  def test_different_column_name
    assert_equal MOVIE_URL, @movie.opengraph_url
  end
  
  def test_meta_tags_helper
    assert_equal GENERATED_META_TAGS, opengraph_meta_tags_for(@movie)
    assert_raise(ArgumentError) { opengraph_meta_tags_for(@song) }
  end

  def test_like_button_helper
    assert_equal GENERATED_LIKE_BUTTON, like_button_for(@movie)
    assert_equal GENERATED_LIKE_BUTTON_CUSTOM_URL, like_button_for(@movie, :href => "http://example.com/movies/6")
    
    @fb_sdk_included = true # Tells our helper we've already included the facebook JS SDK
    assert_equal GENERATED_LIKE_BUTTON_FBXML, like_button_for(@movie, :xfbml => true)
    
    # There's no way of getting the href attribute for this Book, so it returns nil
    assert_nil like_button_for(@book)
    
    # We aren't using acts_as_opengraph for this model, so it should let us know
    assert_raise(ArgumentError) { like_button_for(@song) }
  end
  
end
