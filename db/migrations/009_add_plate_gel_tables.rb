Sequel.migration do
  up do
    create_table :current_plates do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :type
      Integer :number_of_rows
      Integer :number_of_columns
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_plates do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :type
      Integer :number_of_rows
      Integer :number_of_columns
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end

    create_table :current_gels do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      Integer :number_of_rows
      Integer :number_of_columns
      Blob :image
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_gels do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      Integer :number_of_rows
      Integer :number_of_columns
      Blob :image
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end
  end

  down do
    drop_table :current_plates
    drop_table :historic_plates
    drop_table :current_gels
    drop_table :historic_gels
  end
end
