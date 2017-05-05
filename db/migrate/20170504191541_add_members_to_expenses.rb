class AddMembersToExpenses < ActiveRecord::Migration[5.0]
  def change
    enable_extension "hstore"
    add_column :expenses, :members, :hstore, default: {}
    add_index :expenses, :members, using: :gin
  end
end
