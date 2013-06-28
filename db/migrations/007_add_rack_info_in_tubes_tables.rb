Sequel.migration do
  change do
    alter_table :current_tubes do
      add_foreign_key :tube_rack_id, :current_tube_racks, :key => :internal_id
      add_column :location, String
      add_index :tube_rack_id
    end

    alter_table :historic_tubes do
      add_foreign_key :tube_rack_id, :historic_tube_racks, :key => :internal_id
      add_column :location, String
    end
  end
end
