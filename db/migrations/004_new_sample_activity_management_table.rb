Sequel.migration do
  change do
    create_table :sample_management_activity do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64 
      String :order_uuid, :fixed => true, :size => 64 
      String :process
      String :step
      String :tube_uuid, :fixed => true, :size => 64 
      String :spin_column_uuid, :fixed => true, :size => 64 
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
