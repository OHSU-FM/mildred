class SurveyRow < OpenStruct

  def survey_structure
    $ss
  end

  def is_a_q?
    self[:class] == "Q"
  end

  def is_a_sq?
    self[:class] == "SQ"
  end

  def has_children?
    children.count > 0
  end

  def children
    unless is_a_q?
      raise MildredErrors::QuestionTypeMismatchError.new("q on sq")
    end

    children = []
    survey_structure.next_row_is_sq? self, children
  end

  def parent
    unless is_a_sq?
      raise MildredErrors::QuestionTypeMismatchError.new("sq on q")
    end

    survey_structure.prev_row_is_q? self
  end
end
