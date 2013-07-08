Sequel.migration do
  change do
    create_table :sample_management_activity do
      primary_key :internal_id
      foreign_key :uuid, :current_samples, :key => :uuid 
      foreign_key :order_uuid, :current_orders, :key => :uuid 
      String :process
      String :step
      foreign_key :tube_uuid, :current_tubes, :key => :uuid
      foreign_key :spin_column_uuid, :current_spin_columns, :key => :uuid
      String :user
      String :status
      DateTime :date
      TrueClass :is_current
      String :hashed_index

      index :hashed_index
      index [:uuid, :order_uuid]
    end
  end
end
