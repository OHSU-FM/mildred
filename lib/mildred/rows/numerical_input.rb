module Rows
  class NumericalInput < SurveyRow
    def code val
      general_checks val
    end
  end
end
