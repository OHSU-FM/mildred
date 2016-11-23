require_relative "reindeer-etl/lib/reindeer-etl.rb"
require_relative "lib/mildred.rb"

pre_process do
  first_run = true
  CSV.foreach("./tmp/vvexport_471745.csv", {col_sep: "\t", quote_char: "|"}) do |row|
    if first_run
      first_run = false
      if row.select{ |r| !r.nil? }.any?{|r| r.include?(" ")}
        system( "sed -i '1d' './tmp/vvexport_471745.csv'")
      end
    end
  end
  $ss = SurveyStructure.new("./tmp/limesurvey_survey_471745.txt")
end

source(ReindeerETL::Sources::CSVSource, "./tmp/vvexport_471745.csv", {col_sep: "\t", quote_char: "|"})


transform ReindeerETL::Transforms::ResponseStatus, {except: ["id", "token", "submitdate", "lastpage", "startlanguage"]}