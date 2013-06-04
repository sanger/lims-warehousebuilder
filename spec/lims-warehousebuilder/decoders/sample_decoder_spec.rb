require 'lims-warehousebuilder/decoders/spec_helper'
require 'lims-warehousebuilder/builder'
require 'lims-warehousebuilder/json_decoder'

module Lims::WarehouseBuilder::Decoder
  describe SampleDecoder do
    include_context "use database"

    let(:model) { "sample" }
    let(:uuid) { "11111111-2222-3333-4444-555555555555" }
    let(:ancestor_uuid) { mock(:ancestor_uuid) }
    let(:date) { Time.now.utc }
    let(:payload) do 
      {}.tap do |h|
        h["uuid"] = uuid
        h["date"] = date.to_s
        h["ancestor_uuid"] = ancestor_uuid
      end
    end
    let(:decoder) { described_class.new(model, payload) }

    context "new sample" do
      let(:expected_models) {[
        Lims::WarehouseBuilder::Model::Sample, 
        Lims::WarehouseBuilder::Model::SampleContainerHelper, 
        Lims::WarehouseBuilder::Model::SampleManagementActivity
      ]}

      it_behaves_like "a decoder"

      it "returns an array with a sample model, a sample container helper model and a sample management activity model" do
        decoder.call.each do |model|
          expected_models.should include(model.class)
        end
      end
    end

    context "old sample" do
      let(:expected_models) {[
        Lims::WarehouseBuilder::Model::Sample,
        Lims::WarehouseBuilder::Model::SampleContainerHelper
      ]}

      before(:each) do
        Lims::WarehouseBuilder::Model::SampleManagementActivity.new(:uuid => uuid).save      
      end

      it_behaves_like "a decoder"

      it "returns an array without the initial sample management activity model" do
        decoder.call.each do |model|
          expected_models.should include(model.class)
        end
      end
    end

    let(:builder) { Lims::WarehouseBuilder::Builder.new({}, {}) }
    let(:decoded_resources) { builder.send(:decode_payload, payload, action) }

    context "decode bulk create sample message" do
      let(:action) { "create" }
      let(:payload) {
        <<-EOD
        {"bulk_create_sample":{"actions":{},"user":"user","application":"application","result":{"samples":[{"actions":{"read":"http://localhost:9292/e5eedb40-af42-0130-51be-282066132de2","create":"http://localhost:9292/e5eedb40-af42-0130-51be-282066132de2","update":"http://localhost:9292/e5eedb40-af42-0130-51be-282066132de2","delete":"http://localhost:9292/e5eedb40-af42-0130-51be-282066132de2"},"uuid":"e5eedb40-af42-0130-51be-282066132de2","state":"draft","supplier_sample_name":"supplier sample name","gender":"Male","sanger_sample_id":"S2-267bf57412064031af1e36acc73ab92b","sample_type":"RNA","scientific_name":"homo sapiens","common_name":"man","hmdmc_number":"123456","ebi_accession_number":"accession number","sample_source":"sample source","mother":"mother","father":"father","sibling":"sibling","gc_content":"gc content","public_name":"public name","cohort":"cohort","storage_conditions":"storage conditions","taxon_id":9606,"volume":100,"date_of_sample_collection":"2013-06-24T00:00:00+01:00","is_sample_a_control":true,"is_re_submitted_sample":false,"dna":{"pre_amplified":false,"date_of_sample_extraction":"2013-06-02T00:00:00+00:00","extraction_method":"extraction method","concentration":120,"sample_purified":false,"concentration_determined_by_which_method":"method"},"cellular_material":{"lysed":false},"genotyping":{"country_of_origin":"england","geographical_region":"europe","ethnicity":"english"}},{"actions":{"read":"http://localhost:9292/e5ef1d30-af42-0130-51be-282066132de2","create":"http://localhost:9292/e5ef1d30-af42-0130-51be-282066132de2","update":"http://localhost:9292/e5ef1d30-af42-0130-51be-282066132de2","delete":"http://localhost:9292/e5ef1d30-af42-0130-51be-282066132de2"},"uuid":"e5ef1d30-af42-0130-51be-282066132de2","state":"draft","supplier_sample_name":"supplier sample name","gender":"Male","sanger_sample_id":"S2-87aba12f331e44c7b27c620e5316bb8a","sample_type":"RNA","scientific_name":"homo sapiens","common_name":"man","hmdmc_number":"123456","ebi_accession_number":"accession number","sample_source":"sample source","mother":"mother","father":"father","sibling":"sibling","gc_content":"gc content","public_name":"public name","cohort":"cohort","storage_conditions":"storage conditions","taxon_id":9606,"volume":100,"date_of_sample_collection":"2013-06-24T00:00:00+01:00","is_sample_a_control":true,"is_re_submitted_sample":false,"dna":{"pre_amplified":false,"date_of_sample_extraction":"2013-06-02T00:00:00+00:00","extraction_method":"extraction method","concentration":120,"sample_purified":false,"concentration_determined_by_which_method":"method"},"cellular_material":{"lysed":false},"genotyping":{"country_of_origin":"england","geographical_region":"europe","ethnicity":"english"}},{"actions":{"read":"http://localhost:9292/e5ef5fb0-af42-0130-51be-282066132de2","create":"http://localhost:9292/e5ef5fb0-af42-0130-51be-282066132de2","update":"http://localhost:9292/e5ef5fb0-af42-0130-51be-282066132de2","delete":"http://localhost:9292/e5ef5fb0-af42-0130-51be-282066132de2"},"uuid":"e5ef5fb0-af42-0130-51be-282066132de2","state":"draft","supplier_sample_name":"supplier sample name","gender":"Male","sanger_sample_id":"S2-65a19405eea14b50af6e9c1f81f29278","sample_type":"RNA","scientific_name":"homo sapiens","common_name":"man","hmdmc_number":"123456","ebi_accession_number":"accession number","sample_source":"sample source","mother":"mother","father":"father","sibling":"sibling","gc_content":"gc content","public_name":"public name","cohort":"cohort","storage_conditions":"storage conditions","taxon_id":9606,"volume":100,"date_of_sample_collection":"2013-06-24T00:00:00+01:00","is_sample_a_control":true,"is_re_submitted_sample":false,"dna":{"pre_amplified":false,"date_of_sample_extraction":"2013-06-02T00:00:00+00:00","extraction_method":"extraction method","concentration":120,"sample_purified":false,"concentration_determined_by_which_method":"method"},"cellular_material":{"lysed":false},"genotyping":{"country_of_origin":"england","geographical_region":"europe","ethnicity":"english"}}]},"volume":100,"date_of_sample_collection":"2013-06-24","is_sample_a_control":true,"is_re_submitted_sample":false,"hmdmc_number":"123456","ebi_accession_number":"accession number","sample_source":"sample source","mother":"mother","father":"father","sibling":"sibling","gc_content":"gc content","public_name":"public name","cohort":"cohort","storage_conditions":"storage conditions","dna":{"pre_amplified":false,"date_of_sample_extraction":"2013-06-02","extraction_method":"extraction method","concentration":120,"sample_purified":false,"concentration_determined_by_which_method":"method"},"rna":null,"cellular_material":{"lysed":false},"genotyping":{"country_of_origin":"england","geographical_region":"europe","ethnicity":"english"},"common_name":"man","gender":"Male","sample_type":"RNA","taxon_id":9606,"supplier_sample_name":"supplier sample name","scientific_name":"homo sapiens","quantity":3,"state":"draft"},"action":"bulk_create_sample","date":"2013-06-04 12:47:54 UTC","user":"user"}
        EOD
      }

      it "finds the right number of resources" do
        decoded_resources.size.should == 3
      end

      it "finds the right resource models" do
        decoded_resources.each do |resource|
          resource.should be_a(Lims::WarehouseBuilder::Model::Sample)
        end
      end
    end
  end
end
