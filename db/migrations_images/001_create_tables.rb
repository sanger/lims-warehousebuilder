Sequel.migration do
  up do
    create_table :gel_images do
      primary_key :internal_id
      Blob :image
    end

    create_table :gel_image_metadata do
      primary_key :internal_id
      foreign_key :gel_image_id, :gel_images, :key => :internal_id 
      String :uuid, :fixed => true, :size => 64
      String :score
      DateTime :created_at
      index :uuid
    end
  end

  down do
    drop_table :gel_images
    drop_table :gel_image_metadata
  end
end
