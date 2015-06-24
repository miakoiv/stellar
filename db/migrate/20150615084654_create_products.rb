class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.belongs_to :brand,    null: false, index: true
      t.belongs_to :category, null: false, index: true
      t.string :code
      t.string :name
      t.text :memo

      t.timestamps null: false
    end
  end
end
