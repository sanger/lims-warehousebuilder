Sequel.migration do
  change do
    alter_table :current_filter_papers do
      drop_column :number_of_rows
      drop_column :number_of_columns
    end

    alter_table :historic_filter_papers do
      drop_column :number_of_rows
      drop_column :number_of_columns
    end
  end
end
