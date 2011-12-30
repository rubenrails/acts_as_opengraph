module ActiveRecord 
  module Acts
    module Opengraph
      
      def self.included(base)
        base.extend ActMethods
      end
      
      module ActMethods
        def acts_as_opengraph(options = {})
          # don't allow multiple calls
          return if included_modules.include? InstanceMethods
          
          extend ClassMethods
          
          opengraph_atts = %w(title type image url description site_name latitude longitude street_address locality region postal_code country_name email phone_number fax_number)
          
          options[:columns] ||= {}
          options[:values] ||= {}
          
          opengraph_atts.each do |att_name|
            options[:columns]["#{att_name}".to_sym] ||= alternative_column_name_for("og_#{att_name}".to_sym)
          end
          
          class_attribute :opengraph_atts
          self.opengraph_atts = opengraph_atts
          
          class_attribute :options
          self.options = options
          
          opengraph_atts.each do |att_name|
            define_method "opengraph_#{att_name}" do
              return_value_or_default att_name.to_sym
            end
          end
          
          include InstanceMethods
          
        end
        
      end
    
      module ClassMethods
        
        private
        
        # Returns a list of possible column names for a given attribute.
        # 
        # @param [Symbol] att_name An opengraph attribute name prefixed with 'og_', i.e. :og_title, :og_type, etc
        # @return [Array] A list of possible names for the given opengraph attribute
        def alternative_names_for(att_name)
          case att_name
            when :og_title          then [:title, :name]
            when :og_type           then [:kind, :category]
            when :og_image          then [:image, :photo, :picture, :thumb, :thumbnail]
            when :og_url            then [:url, :uri, :link]
            when :og_description    then [:description, :summary]
            when :og_site_name      then [:site, :website, :web]
            when :og_latitude       then [:latitude]
            when :og_longitude      then [:longitude]
            when :og_street_address then [:street_address, :address, :street]
            when :og_locality       then [:locality]
            when :og_region         then [:region]
            when :og_postal_code    then [:postal_code, :zip_code, :zip]
            when :og_country_name   then [:country_name, :country]
            when :og_email          then [:email, :mail]
            when :og_phone_number   then [:phone_number, :phone]
            when :og_fax_number     then [:fax_number, :fax]
            else []
          end
        end
        
        # Tries to guess the column name for the given attribute. If it can't find any column (or similar) then it will create a virtual attribute
        # for the object called: ATT_NAME_placeholder, so the object responds to that column.
        # 
        # @param [Symbol] att_name An opengraph attribute name prefixed with 'og_', i.e. :og_title, :og_type, etc
        # @return [String] The final name (found or created) for the opengraph attribute
        def alternative_column_name_for(att_name)
          alt_names = alternative_names_for(att_name)
          columns_to_check = [att_name] + alt_names
          columns_to_check.each do |column_name| 
            return column_name.to_sym if column_names.include?(column_name.to_s)
          end
          
          # Define placeholder method
          ph_method_name = "#{alt_names.first}_placeholder"
          define_method(ph_method_name) { "" }
          ph_method_name
        end
        
      end
      
      module InstanceMethods
        # Returns an array of hashes representing the opengraph attribute/values for the Object.
        #
        # @return [Array] List of hashes representing opengraph attribute/values
        # @example
        #   @movie.opengraph_data #=> {name=> "og:title", :value => "The Rock"}, {:name => "og:type", :value=> "movie"}
        def opengraph_data
          data_list = opengraph_atts.map do |att_name|
            {:name => "og:#{att_name}", :value => self.send("opengraph_#{att_name}")}
          end
          data_list.delete_if{ |el| el[:value].blank?  }
        end
        
        
        private
        
        def return_value_or_default(att_name)
          if options[:values].has_key?(att_name.to_sym)
            options[:values][att_name]
          else
            self.send options[:columns]["#{att_name}".to_sym]
          end
        end
        
      end
    
    end
  end
end
