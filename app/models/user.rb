class User < ActiveRecord::Base
  has_many :tweets

  def slug
   self.username.ljust(100).strip.gsub(/[\s\t\r\n\f]/,'-').gsub(/\W/,'-').downcase
 end

 def self.find_by_slug(slug)
   self.find do |s|
     s.slug == slug
   end
 end

  has_secure_password
end
