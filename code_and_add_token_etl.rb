require "reindeer-etl"

sid = 363317

pre_process do
  first_run = true
  CSV.foreach("./tmp/vvexport_#{sid}.csv", {col_sep: "\t", quote_char: "|"}) do |row|
    if first_run
      first_run = false
      if row.select{ |r| !r.nil? }.any?{|r| r.include?(" ")}
        system( "sed -i '1d' './tmp/vvexport_#{sid}.csv'")
      end
    end
  end
end

source(ReindeerETL::Sources::CSVSource, "./tmp/vvexport_#{sid}.csv", {col_sep: "\t", quote_char: "|"})

transform(ReindeerETL::Transforms::ResponseStatus, "./tmp/limesurvey_survey_#{sid}.txt", {except: ["id", "token", "submitdate", "lastpage", "startlanguage", "startdate", "datestamp", "ipaddr"]})

destination(ReindeerETL::Destinations::CSVDest, "./tmp/step1_#{sid}.csv")

source(ReindeerETL::Sources::MultiSource, "token",
       ["./tmp/step1_#{sid}.csv", "./tmp/tokens_#{sid}.csv"],
       target_cols: [["GradYear", "LotProgramId", "LotProgramAlias", "ABFMLastFour", "LotProgramCivilian", "LotProgramYrs"]],
       namespace: "LotGradYr2"
      )

destination(ReindeerETL::Destinations::CSVDest, "./tmp/recoded_#{sid}.csv", {col_sep: "\t"})