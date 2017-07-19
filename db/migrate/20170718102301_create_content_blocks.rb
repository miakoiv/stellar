class CreateContentBlocks < ActiveRecord::Migration
  def change
    create_table :content_blocks do |t|
      t.belongs_to :section, null: false, index: true
      t.integer :template, null: false, default: 0
      t.belongs_to :resource, polymorphic: true, index: true
      t.string :headline
      t.string :subhead
      t.text :body
      t.integer :priority, null: false, default: 0

      t.timestamps null: false
    end
  end
end
