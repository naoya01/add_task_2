class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :follow_id
      t.integer :followed_id

      t.timestamps
      t.index [:follow_id, :followed_id], unique: true
    end
  end
end
