require "pry"
require_relative "lib/mildred"
require_relative "lib/mildred/survey_structure"

t=SurveyStructure.new("./tmp/limesurvey_survey_471745.csv")
binding.pry

# discard = ["S", "SL"]
# first_run = true
#
# path = "./limesurvey_survey_471745.csv"
# CSV.foreach(path, col_sep: "\t") do |row|
#   begin
#     binding.pry if ["G","Q","SQ","A"].include? row.first
#   rescue => e
#     binding.pry
#   end
# end
