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

source(ReindeerETL::Sources::MultiSource, "token",
       ["./tmp/#{sid}/step1_#{sid}.csv", "./tmp/#{sid}/tokens_#{sid}.csv"],
       target_cols: [["GradYear", "LotProgramId", "LotProgramAlias", "AbfmLastFour", "LotProgramCivilian", "LotProgramYrs"]],
       # target_cols: [["LotProgramId", "LotProgramAlias", "LotProgramCivilian", "LotProgramYrs"]],
       namespace: "LotGradYr3"
      )

destination(ReindeerETL::Destinations::CSVDest, "./tmp/#{sid}/recoded_#{sid}.csv", {col_sep: "\t"})
