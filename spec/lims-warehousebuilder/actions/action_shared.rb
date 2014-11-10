  def create_plate(uuid, date, user, number_of_rows, number_of_columns)
    Lims::WarehouseBuilder::Model.model_for("plate").new(
      :uuid               => uuid,
      :created_at         => date,
      :created_by         => user,
      :number_of_rows     => number_of_rows,
      :number_of_columns  => number_of_columns)
  end
  
  def create_fluidigm(uuid, date, user, number_of_rows, number_of_columns)
    Lims::WarehouseBuilder::Model.model_for("fluidigm").new(
      :uuid               => uuid,
      :created_at         => date,
      :created_by         => user,
      :number_of_rows     => number_of_rows,
      :number_of_columns  => number_of_columns)
  end
  
shared_context "create payloads" do

  let(:source_plate_uuid) { "11111111-2222-3333-4444-555555555555" }
  let(:target_plate_uuid) { "11111111-2222-3333-4444-666666666666" }
  let(:target_fluidigm_chip_uuid) { "11111111-2222-3333-4444-666666666666" }
  let(:sample1_uuid) { "11111111-0000-0000-0000-111111111111" }
  let(:sample2_uuid) { "11111111-0000-0000-0000-222222222222" }
  let(:date) { Time.now.utc }
  let(:update_date) { Time.now.utc + 100 }
  let(:user) { "username" }
  let(:update_user) { "update user" }
  let(:number_of_rows_plate) { 8 }
  let(:number_of_columns_plate) { 12 }
  let(:number_of_rows_fluidigm_chip) { 12 }
  let(:number_of_columns_fluidigm_chip) { 16 }

  let(:source_plate_payload) do
    { "plate" => {
        "uuid" => source_plate_uuid,
        "type" => "plate type",
        "number_of_rows" => 8,
        "number_of_columns" => 12,
        "date" => update_date,
        "user" => update_user
      }
    }
  end
  let(:target_plate_payload) do
    { "plate" => {
        "uuid" => target_plate_uuid,
        "type" => "plate type",
        "number_of_rows" => 8,
        "number_of_columns" => 12,
        "date" => update_date,
        "user" => update_user
      }
    }
  end


  let(:target_fluidigm_chip_payload) do
    { "fluidigm" => {
        "uuid" => target_fluidigm_chip_uuid,
        "number_of_rows" => number_of_rows_fluidigm_chip,
        "number_of_columns" => number_of_columns_fluidigm_chip,
        "date" => update_date,
        "user" => update_user
      }
    }
  end

end
