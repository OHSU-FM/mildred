require_relative "reindeer-etl/lib/reindeer-etl.rb"

pre_process do
  first_run = true
  CSV.foreach("./tmp/vvexport_487866.csv", {col_sep: "\t", quote_char: "|"}) do |row|
    if first_run
      first_run = false
      if row.select{ |r| !r.nil? }.any?{|r| r.include?(" ")}
        system( "sed -i '1d' './tmp/vvexport_487866.csv'")
      end
    end
  end
end

source(ReindeerETL::Sources::CSVSource, "./tmp/vvexport_487866.csv", {col_sep: "\t", quote_char: "|"})

transform ReindeerETL::Transforms::ResponseStatus, "./tmp/limesurvey_survey_487866.txt", {except: ["id", "token", "submitdate", "lastpage", "startlanguage", "startdate", "datestamp"]}

destination ReindeerETL::Destinations::CSVDest, "./tmp/test.csv"
