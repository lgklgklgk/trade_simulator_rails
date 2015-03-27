class NewTable < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :position
      t.float  :war
      t.integer :team_id
    end
    
    create_table :teams do |t|
      t.string :name
      t.string :general_manager
      t.string :images
      t.string :abbreviation
    end
    
    create_table :trades do |t|
      t.string :accepted
    end
    
    create_table :transactions do |t|
      t.integer :player_id
      t.string  :source
      t.string  :destination
      t.integer :trade_id
    end
  end
end
