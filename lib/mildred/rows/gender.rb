module Rows
  class GenderRow < SurveyRow
    # TODO implement coding for "No answer"
    def code val
      if ["M", "F"].include? val
        "E111E"
      else
        "E999E"
      end
    end
  end
end
