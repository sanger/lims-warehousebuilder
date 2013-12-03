Sequel.migration do
  up do
    # Fluidigm
    create_table :current_fluidigms do
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

    create_table :historic_fluidigms do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      Integer :number_of_rows
      Integer :number_of_columns
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
    end

    # Snp asset
    create_table :current_snp_assets do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :name
      String :allele_x
      String :allele_y
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    create_table :historic_snp_assets do
      primary_key :internal_id
      String :uuid, :fixed => true, :size => 64
      String :name
      String :allele_x
      String :allele_y
      DateTime :created_at
      DateTime :updated_at
      String :created_by
      String :updated_by
      index :uuid
    end

    # helper
    create_table :snp_asset_container_helper do
      primary_key :internal_id
      String :snp_asset_uuid, :fixed => true, :size => 64
      String :container_uuid, :fixed => true, :size => 64
      index :container_uuid
    end
  end

  down do
    drop_table :current_fluidigms
    drop_table :historic_fluidigms
    drop_table :current_snp_assets
    drop_table :historic_snp_assets
    drop_table :snp_asset_container_helper
  end
end
