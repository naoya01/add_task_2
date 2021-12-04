class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.text :body
      t.string :category
      t.integer :user_id
      t.float :evaluation, null: false
      t.timestamps
    end
  end
end
