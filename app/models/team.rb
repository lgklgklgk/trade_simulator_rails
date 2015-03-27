class Team < ActiveRecord::Base
  has_many :players
  has_many :transactions
  attr_accessible :name, :abbreviation, :general_manager, :image
end
