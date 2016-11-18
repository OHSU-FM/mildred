require "rspec"
require "yaml"
require "pry"

require_relative "../models/survey_structure"
require_relative "../models/survey_row"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
    c.syntax = :expect
  end
end

def from_fixture
  "./spec/fixtures/limesurvey_survey.csv"
end

def row_from_fixture fixture_path
  survey_row = SurveyRow.new
  YAML.load_file("spec/fixtures/#{fixture_path}.yaml").map {|k, v| survey_row[k] = v }
  survey_row
end
