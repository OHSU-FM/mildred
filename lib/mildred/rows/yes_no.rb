module Rows
  class YesNo < SurveyRow
    def code val
      ecode = general_checks val
      if ecode.nil?
        if ["Y", "N"].include? val
          "111"
        else
          "999"
        end
      else
        ecode
      end
    end
  end
end
