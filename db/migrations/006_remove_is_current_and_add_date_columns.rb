Sequel.migration do
  change do
    alter_table :sample_management_activity do
      drop_column :is_current
      drop_column :date
      add_column :current_from, DateTime
      add_column :current_to, DateTime
    end
  end
end
