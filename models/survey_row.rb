require "ostruct"

class SurveyRow < OpenStruct
  def is_a_q?
    self[:class] == "Q"
  end

  def is_a_sq?
    self[:class] == "SQ"
  end
end
