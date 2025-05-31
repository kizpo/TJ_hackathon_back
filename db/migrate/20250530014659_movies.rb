class Movies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :excitement
      t.integer :joy
      t.integer :fear
      t.integer :sadness
      t.integer :surprise
  
      t.timestamps
    end
  end
end
