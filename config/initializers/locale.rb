# this file does nothing - due to an error in I18n implementation as of 2014-10-22


# # tell the I18n library where to find your translations
# I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
# #
# # if sub directories to config/locales - like config/locales/employees - then:
# #   I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
#
# # set default locale to something other than :en
# I18n.default_locale = :da

# module I18n
#   class << self
#     def oxt key, args={}
#       scope_prefix =args.include?( :prefix ) ? ".#{args.delete(:prefix)}" : ""
#       scope_suffix =args.include?( :suffix ) ? ".#{args.delete(:suffix)}" : ""
#       domain =  self.respond_to?(:resource_class) ? "." + resource_class.to_s.underscore.downcase : ""
#       args.merge!( scope: "oxenserver#{scope_prefix}#{domain}#{scope_suffix}" ) rescue {}
#       t(key.to_sym, args )
#     end
#
#     # # SELECT DISTINCT locale FROM `translations`  WHERE (translations.ox_id='1') AND (translations.state='production')
#     # def available_locales(ox_id=ENV['OX_ID'], state=nil)
#     #   state ||= 'production'
#     #   Translation.unscoped.find(:all, :select => 'DISTINCT locale', :conditions => ["ox_id=? AND state=?", ox_id, state]).map { |t| t.locale.to_sym }
#     # rescue
#     #   []
#     # end
#
#   end
#
# end
#
# #
# # make models able to log all kinds of errors/info
# module ActiveModel
#   class Validator
#     def oxt( key, *args )
#       args.any? ? I18n.oxt( key, args[0]) : I18n.oxt( key)
#     end
#   end
# end
