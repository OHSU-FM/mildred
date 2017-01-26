require "reindeer-etl"

sid = 692985

pre_process do
  first_run = true
  CSV.foreach("./tmp/#{sid}/vvexport_#{sid}.csv", {col_sep: "\t", quote_char: "|"}) do |row|
    if first_run
      first_run = false
      if row.select{ |r| !r.nil? }.any?{|r| r.include?(" ")}
        system( "sed -i '1d' './tmp/#{sid}/vvexport_#{sid}.csv'")
      end
    end
  end
end

source(ReindeerETL::Sources::CSVSource, "./tmp/#{sid}/vvexport_#{sid}.csv", {col_sep: "\t", quote_char: "|"})

transform(ReindeerETL::Transforms::ResponseStatus, "./tmp/#{sid}/limesurvey_survey_#{sid}.txt", {except: ["startdate", "datestamp", "id", "token", "submitdate", "lastpage", "startlanguage", "ipaddr"], complete: true})

destination(ReindeerETL::Destinations::CSVDest, "./tmp/#{sid}/step1_#{sid}.csv")
