module Rows
  class MultNumeric < SurveyRow
    def code val, sq=nil
      ecode = general_checks val
      if ecode.nil?
        if @check_skip
          # TODO check skip
        end

        if mandatory == "Y" && !val.nil?
          ecode = "111"
        else
          ecode = "999"
        end
      end
      ecode
    end
  end
end
