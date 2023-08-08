class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys do |t|
      t.integer :user_id
      t.string :name
      t.string :slug
      t.json :payloads

      t.timestamps
    end

    add_index :surveys, :user_id
    add_index :surveys, :slug, unique: true
  end
end
