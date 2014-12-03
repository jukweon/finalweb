class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_one :background
end
