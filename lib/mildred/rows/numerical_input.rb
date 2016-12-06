module Rows
  class NumericalInput < SurveyRow
    def code val
      ecode = general_checks val
      if ecode.nil?
        if @check_skip
          # check skip
        end

        if mandatory == "Y" && !val.nil?
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
