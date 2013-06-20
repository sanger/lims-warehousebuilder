Sequel.migration do
  up do
    create_table :current_barcodes do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :ean13_barcode
      String :sanger_barcode
      String :barcoded_resource_uuid
      String :position
      DateTime :created_at
      String :created_by
      index :ean13_barcode
      index :sanger_barcode
    end

    create_table :historic_barcodes do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :ean13_barcode
      String :sanger_barcode
      String :barcoded_resource_uuid
      String :position
      DateTime :created_at
      String :created_by
    end
  end

  down do
    drop_table :current_barcodes
    drop_table :historic_barcodes
  end
end
