class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.references :user, index: true
      t.float :amount
      t.string :description
      t.references :resource, polymorphic: true, index: true
      t.timestamps
    end
  end
end
