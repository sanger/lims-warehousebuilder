Sequel.migration do
  up do
    # tubes
    create_table :current_tubes do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :type
      Integer :max_volume
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_tubes do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :type
      Integer :max_volume
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end

    # tube_racks
    create_table :current_tube_racks do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      Integer :number_of_rows
      Integer :number_of_columns
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_tube_racks do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      Integer :number_of_rows
      Integer :number_of_columns
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end

    # spin columns
    create_table :current_spin_columns do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_spin_columns do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end

    # samples
    create_table :current_samples do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :name
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_samples do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :name
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end

    # orders
    create_table :current_orders do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :pipeline
      String :status
      String :cost_code
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_orders do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :pipeline
      String :status
      String :cost_code
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end

    # items
    create_table :current_items do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :batch_uuid, :fixed => true, :size => 64
      String :status
      String :role
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_items do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :batch_uuid, :fixed => true, :size => 64
      String :status
      String :role
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end

    # helper
    create_table :sample_container_helper do
      primary_key :internal_id
      String :sample_uuid, :fixed => true, :size => 64
      String :container_uuid, :fixed => true, :size => 64
      index :container_uuid
    end
 end

  down do
    drop_table :current_tubes
    drop_table :historic_tubes
    drop_table :current_tube_racks
    drop_table :historic_tube_racks
    drop_table :current_spin_columns
    drop_table :historic_spin_columns
    drop_table :current_samples
    drop_table :historic_samples
    drop_table :current_orders
    drop_table :historic_orders
    drop_table :current_items
    drop_table :historic_items
    drop_table :sample_container_helper
  end
end

