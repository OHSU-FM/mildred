module Rows
  class ListDropdown < SurveyRow
    def code val
      general_checks val
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
