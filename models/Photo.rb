class Photo < ActiveRecord::Base
  belongs_to :album
  #belongs_to :album, -> { includes :user }
end
