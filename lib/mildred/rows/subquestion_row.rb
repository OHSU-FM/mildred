module Rows
  class Subquestion < SurveyRow
    def code val
      ecode = general_checks val
      if ecode.nil?
        ecode = parent.code(val, self)
      end
      binding.pry if index == 223
      ecode
    end
  end
end
