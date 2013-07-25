Sequel.migration do
  change do
    alter_table :current_tube_racks do
      add_column :deleted_at, DateTime
      add_column :deleted_by, String
    end

    alter_table :historic_tube_racks do
      add_column :deleted_at, DateTime
      add_column :deleted_by, String
    end
  end
end
