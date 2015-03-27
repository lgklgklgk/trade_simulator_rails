class Transaction < ActiveRecord::Base
  attr_accessible :player_id, :source, :destination, :trade_id
end
