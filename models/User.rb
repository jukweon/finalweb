class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :albums
  #has_many :photos, :through => :albums
  has_secure_password
end
