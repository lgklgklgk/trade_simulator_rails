class EditTransactionsTableAgain < ActiveRecord::Migration
  def change
    remove_column :transactions, :team_id
  end
end
