class EditTransactionsTable < ActiveRecord::Migration
  def change
    remove_column :transactions, :destination
    add_column :transactions, :team_id, :integer
  end
end
