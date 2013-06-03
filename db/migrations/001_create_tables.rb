DNA_RNA_MANUAL_EXTRACTION_ROLES = ["manual_dna_and_rna_input_tube_nap",
                                   "manual_dna_and_rna_binding_input_tube_nap",
                                   "manual_spin_column_dna",
                                   "manual_dna_and_rna_byproduct_tube_rnap",
                                   "manual_extracted_tube_dna",
                                   "manual_dna_and_rna_binding_input_tube_rnap",
                                   "manual_spin_column_rna",
                                   "manual_extracted_tube_rna",
                                   "manual_name_rna",
                                   "manual_name_dna",
                                   "manual_stock_rna",
                                   "manual_stock_dna"]
# TODO: add cancelled and failed
ORDER_ITEM_STATUS = ["pending", "in_progress", "done", "unused"]

Sequel.migration do
  up do

    # sample_management_activity
    [:current_sample_management_activity, :historic_sample_management_activity].each do |table|
      sequel = "create_table :#{table} do;".tap do |s|
        s << "primary_key :internal_id;"
        s << "String :uuid, :fixed => true, :size => 64;"
        DNA_RNA_MANUAL_EXTRACTION_ROLES.each do |role|
          s << "String :#{role}_uuid, :fixed => true, :size => 64;"
          ORDER_ITEM_STATUS.each do |status|
            s << "String :#{role}_#{status}_by;"
            s << "DateTime :#{role}_#{status}_at;"
          end
        end
        s << "index :uuid;" if table.to_s == "current_sample_management_activity"
        s << "end"
      end
      self.instance_eval(sequel)
    end

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
    drop_table :current_sample_management_activity
    drop_table :historic_sample_management_activity
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

