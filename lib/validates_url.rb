# -*- encoding : utf-8 -*-


require 'net/http'
require 'uri/http'


#http://www.simonecarletti.com/blog/2009/04/validating-the-format-of-an-url-with-rails/
#   class Site < ActiveRecord::Base
#     validates_format_of :url, :on => :create
#     validates_format_of :ftp, :schemes => [:ftp, :http, :https]
#   end
#
# ==== Configurations
#
# * :schemes - An array of allowed schemes to match against (default is [:http, :https])
# * :message - A custom error message (default is: "is invalid").
# * :allow_nil - If set to true, skips this validation if the attribute is +nil+ (default is +false+).
# * :allow_blank - If set to true, skips this validation if the attribute is blank (default is +false+).
# * :on - Specifies when this validation is active (default is :save, other options :create, :update).
# * :if - Specifies a method, proc or string to call to determine if the validation should
#   occur (e.g. :if => :allow_validation, or :if => Proc.new { |user| user.signup_step > 2 }).  The
#   method, proc or string should return or evaluate to a true or false value.
# * :unless - Specifies a method, proc or string to call to determine if the validation should
#   not occur (e.g. :unless => :skip_validation, or :unless => Proc.new { |user| user.signup_step <= 2 }).  The
#   method, proc or string should return or evaluate to a true or false value.
#

      def validates_format_of_url(*attr_names)
        configuration = { :on => :save, :schemes => %w(http https) }
        configuration.update(attr_names.extract_options!)

        allowed_schemes = [*configuration[:schemes]].map(&:to_s)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          begin
            uri = URI.parse(value)

            if !allowed_schemes.include?(uri.scheme)
              raise(URI::InvalidURIError)
            end

            if [:scheme, :host].any? { |i| uri.send(i).blank? }
              raise(URI::InvalidURIError)
            end

          rescue URI::InvalidURIError => e
            record.errors.add(attr_name, :invalid, :default => configuration[:message], :value => value)
            next
          end
        end
      end


      def validates_uri_existence_of(*attr_names)
        configuration = { :message => "is not valid or not responding", :on => :save, :with => nil }
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

        raise(ArgumentError, "A regular expression must be supplied as the :with option of the configuration hash") unless configuration[:with].is_a?(Regexp)

        validates_each(attr_names, configuration) do |r, a, v|
          if v.to_s =~ configuration[:with] # check RegExp
            begin # check header response
              case Net::HTTP.get_response(URI.parse(v))
              when Net::HTTPSuccess then true
              else r.errors.add(a, configuration[:message]) and false
              end
            rescue # Recover on DNS failures..
              r.errors.add(a, configuration[:message]) and false
            end
          else
            r.errors.add(a, configuration[:message]) and false
          end
        end
      end
