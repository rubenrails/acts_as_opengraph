# acts\_as\_opengraph

ActiveRecord extension that turns your models into [facebook opengraph](http://developers.facebook.com/docs/opengraph/) objects.
 
## Installation

	gem install acts_as_opengraph
	
Now just add the gem dependency in your projects configuration. 

## Usage

### Adding acts\_as\_opengraph

	# app/models/movie.rb
	class Movie < ActiveRecord::Base
		acts_as_opengraph
	end
	
### Generating the opengraph meta tags
	
	# app/views/layouts/application.html.erb	
	<head>
		<%= yield :opengraph_meta_tags %>
	</head>
	
	# app/views/movies/show.html.erb
	<% content_for :opengraph_meta_tags, opengraph_meta_tags_for(@movie) %>
	
### Displaying the Like Button
	# app/views/movies/show.html.erb
	<%= like_button_for @movie %>

\* Notice that the Like Button will retrieve the required `href` attribute by calling `@movie.opengraph_url`. Read below for more options. 

	
## Options

### Database columns

Even when the names of these columns can be changed with configuration, `acts_as_opengraph` tries to guess these names by checking for the existence of common names. Chances are that your model already has some of the opengraph defined properties. 

This is the list of supported opengraph protocol properties and their possible column names (in precedence order):

* __title__  - og\_title, title, name
* __type__ - og\_type, kind, category
* __image__ - og\_image, image, photo, picture, thumb, thumbnail
* __url__ - og\_url, url, uri, link
* __description__ - og\_description, description, summary
* __site\_name__ - og\_site, website, web
* __latitude__ - og\_latitude, latitude
* __longitude__ - og\_longitude, longitude
* __street\_address__ - og\_street\_address, street_address, address, street
* __locality__ - og\_locality, locality
* __region__ - og\_region, region
* __postal\_code__ - og\_postal\_code, postal\_code, zip\_code, zip
* __country\_name__ - og\_country_name, country\_name, country
* __email__ - og\_email, email, mail
* __phone\_number__ - og\_phone\_number, phone\_number, phone
* __fax\_number__ - og\_fax\_number, fax\_number, fax

### Using a different column name

If you need to use a different column then use the __columns__ option. For example, if you store the url of your movies using the `imdb_url` column in your movies table, then do this:

	# app/models/movie.rb
	acts_as_opengraph :columns => { :url => :imdb_url }
	
### What about using a custom method?

If you wish to use a custom method for some opengraph field, then all you need to do is to define a method with the prefix `opengraph_`. 
For example, if you are using [Paperclip](https://github.com/thoughtbot/paperclip) for your image attachments, you can do this:

	# app/models/movie.rb
	class Movie < ActiveRecord::Base
	
		has_attached_file :picture, :styles => { :small => "160x130>"}
	
		acts_as_opengraph
		
		def opengraph_image
			picture.url(:small)
		end
		
	end
	
### Default values

Use the __values__ option for passing default opengraph values. For our Movie example we can specify that all of our records are movies by doing this:

	acts_as_opengraph :values => { :type => "movie" }
	
\* Notice that `acts_as_opengraph` only accepts an options hash argument, so if you want to combine default values and column names you'd do this:

	acts_as_opengraph :columns => { :url => :imdb_url, :email => :contact }, 
	                  :values => { :type => "movie", :site_name => "http://example.com" }
	
## Like Button options

Along with the object for which you want to display the Like button, you can pass an options hash to configure its appearance:

	# app/views/layouts/application.html.erb	
	<%= like_button_for @movie, :layout => :box_count, :show_faces => true  %>
	
### Using url helpers

By default, `acts_as_opengraph` will try to retrieve your object's url by calling `opengraph_url` on it. You could override it by defining a custom method, like this:

	# app/models/movie.rb
	def opengraph_url
		"http://example.com/movies/#{self.id}"
	end
	
But that's not the Rails way, so instead of doing that, you can pass an `href` option from your views, which means you can easily take advantage of the url helpers, like this:

	# app/views/movies/show.html.erb
	<%= like_button_for @movie, :href => movie_path(@movie) %>
	
See the complete list of allowed attributes and options [here](http://developers.facebook.com/docs/reference/plugins/like/).

### Using the XFBML version

The XFBML version is more versatile, but requires use of the JavaScript SDK.

	# app/views/movies/show.html.erb
	
	# You can use the following helper method to load the JavaScript SDK
	<%= fb_javascript_include_tag YOUR_APP_ID %>
	
	# Now you can pass the :xfbml option to the like button helper
	<%= like_button_for @movie, :xfbml => true %>

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don’t break it in a future version unintentionally.
* Send me a pull request. Bonus points for topic branches.

## Contributors

* [Eric Hill](https://github.com/rhizome) - Updated the meta attribute to reflect the current OG spec
* [Timo Göllner](https://github.com/TeaMoe) - Integrated Like Button via facebook XFBML tag

## Copyright

Copyright &copy; 2011 Ruben Ascencio, released under the MIT license 






