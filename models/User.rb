class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :albums, dependent: :destroy
  #has_many :photos, :through => :albums
  has_secure_password
end
