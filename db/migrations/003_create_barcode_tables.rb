Sequel.migration do
  up do
    create_table :current_barcodes do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :ean13_barcode
      String :ean13_barcode_position
      String :sanger_barcode
      String :sanger_barcode_position
      String :barcoded_resource_uuid
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :ean13_barcode
      index :sanger_barcode
    end

    create_table :historic_barcodes do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :ean13_barcode
      String :ean13_barcode_position
      String :sanger_barcode
      String :sanger_barcode_position
      String :barcoded_resource_uuid
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end
  end

  down do
    drop_table :current_barcodes
    drop_table :historic_barcodes
  end
end
