module Rows
  class ListDdRow < SurveyRow
    def code val
      if general_code val == "E999E"
        "E999E"
      elsif answers.map{|a| a.text }.include? val
        "E111E"
      else
        binding.pry
      end
    end
  end
end
