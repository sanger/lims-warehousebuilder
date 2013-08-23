Sequel.migration do
  change do
    alter_table :current_tubes do
      add_column :location, String
      add_column :tube_rack_uuid, String, :fixed => true, :size => 64
      add_index :tube_rack_uuid
    end

    alter_table :historic_tubes do
      add_column :tube_rack_uuid, String, :fixed => true, :size => 64
      add_column :location, String
    end
  end
end
