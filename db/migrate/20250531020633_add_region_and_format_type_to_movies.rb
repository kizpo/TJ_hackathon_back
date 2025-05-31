class AddRegionAndFormatTypeToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :region, :string
    add_column :movies, :format_type, :string

    add_index :movies, :region
    add_index :movies, :format_type
  end
end
