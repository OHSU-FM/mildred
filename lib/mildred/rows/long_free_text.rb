module Rows
  class LongFreeText < SurveyRow
    def code val, sq=nil
      ecode = general_checks val
      if ecode.nil?
        if val.nil?
          if mandatory == "Y"
            ecode = "999"
          else
            ecode = "222"
          end
          if relevance.include? "NAOK"
            t=relevance[/\(\((.*?)\)\)/m, 1]
            q = t.split(".")[0]
            tar = t[/\"(.*?)\"/m, 1]
            if $ss.find_by_name(q, nil).val == tar
              ecode = "999"
            end
          end
        elsif !val.nil?
          ecode = "111"
        end
      end
      ecode
    end
  end
end
