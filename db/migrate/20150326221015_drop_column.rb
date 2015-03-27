class DropColumn < ActiveRecord::Migration
  def change
    remove_column :transactions, :source  
  end
end