Sequel.migration do
  change do
    alter_table :current_samples do
      add_column :hmdmc_number, String
      add_column :supplier_sample_name, String
      add_column :common_name, String
      add_column :taxon_id, Integer
      add_column :gender, String
      add_column :sanger_sample_id, String
      add_column :sample_type, String
      add_column :ebi_accession_number, String
      add_column :volume, Integer
      add_column :sample_source, String
      add_column :date_of_sample_collection, DateTime
      add_column :is_sample_a_control, TrueClass
      add_column :is_re_submitted_sample, TrueClass
      add_column :mother, String
      add_column :father, String
      add_column :sibling, String
      add_column :gc_content, String
      add_column :public_name, String
      add_column :cohort, String
      add_column :storage_conditions, String

      add_column :dna_pre_amplified, TrueClass
      add_column :dna_date_of_sample_extraction, DateTime
      add_column :dna_extraction_method, String
      add_column :dna_concentration, Integer
      add_column :dna_sample_purified, TrueClass
      add_column :dna_concentration_determined_by_which_method, String

      add_column :rna_pre_amplified, TrueClass
      add_column :rna_date_of_sample_extraction, DateTime
      add_column :rna_extraction_method, String
      add_column :rna_concentration, Integer
      add_column :rna_sample_purified, TrueClass
      add_column :rna_concentration_determined_by_which_method, String

      add_column :genotyping_country_of_origin, String
      add_column :genotyping_geographical_region, String
      add_column :genotyping_ethnicity, String

      add_column :cellular_material_lysed, TrueClass

      drop_column :name
    end


    alter_table :historic_samples do
      add_column :hmdmc_number, String
      add_column :supplier_sample_name, String
      add_column :common_name, String
      add_column :taxon_id, Integer
      add_column :gender, String
      add_column :sanger_sample_id, String
      add_column :sample_type, String
      add_column :ebi_accession_number, String
      add_column :volume, Integer
      add_column :sample_source, String
      add_column :date_of_sample_collection, DateTime
      add_column :is_sample_a_control, TrueClass
      add_column :is_re_submitted_sample, TrueClass
      add_column :mother, String
      add_column :father, String
      add_column :sibling, String
      add_column :gc_content, String
      add_column :public_name, String
      add_column :cohort, String
      add_column :storage_conditions, String

      add_column :dna_pre_amplified, TrueClass
      add_column :dna_date_of_sample_extraction, DateTime
      add_column :dna_extraction_method, String
      add_column :dna_concentration, Integer
      add_column :dna_sample_purified, TrueClass
      add_column :dna_concentration_determined_by_which_method, String

      add_column :rna_pre_amplified, TrueClass
      add_column :rna_date_of_sample_extraction, DateTime
      add_column :rna_extraction_method, String
      add_column :rna_concentration, Integer
      add_column :rna_sample_purified, TrueClass
      add_column :rna_concentration_determined_by_which_method, String

      add_column :genotyping_country_of_origin, String
      add_column :genotyping_geographical_region, String
      add_column :genotyping_ethnicity, String

      add_column :cellular_material_lysed, TrueClass

      drop_column :name
    end
  end
end
