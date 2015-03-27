class Player < ActiveRecord::Base
  belongs_to :team
  has_many :transactions
  attr_accessible :first_name, :last_name, :position, :war, :team_id
end
