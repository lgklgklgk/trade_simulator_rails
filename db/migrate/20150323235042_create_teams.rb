class CreateTeams < ActiveRecord::Migration
  def change
      drop_table :teams 
      create_table :teams do |t|
        t.string :name
        t.string :general_manager
        t.string :image
        t.string :abbreviation
      end

      
    
  end
end
