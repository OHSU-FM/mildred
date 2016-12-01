class SurveyRow < OpenStruct

  CODES = {
    "E111E" => "Answered",
    "E222E" => "Optional - Unanswered",
    "E333E" => "Optional - Answered",
    "E555E" => "Invalid Response",
    "E777E" => "Skipped/Not Asked",
    "E888E" => "Not Applicable",
    "E999E" => "Missing"
  }

  def survey_structure
    $ss
  end

  def is_a_q?
    self[:class] == "Q"
  end

  def is_a_sq?
    self[:class] == "SQ"
  end

  def is_a_g?
    self[:class] == "G"
  end

  def is_a_a?
    self[:class] == "A"
  end

  def has_children?
    children.count > 0
  end

  def children
    unless is_a_q?
      raise MildredError::QuestionTypeMismatchError.new("q on sq")
    end

    children = []
    survey_structure.next_row_is_sq? self, children
  end

  def parent
    unless is_a_sq?
      raise MildredError::QuestionTypeMismatchError.new("sq on q")
    end

    survey_structure.prev_row_is_q? self
  end

  def answers
    answers = []
    survey_structure.answers_for_row self, answers
  end

  # catches coding cases that apply to all row subclasses
  def general_checks val
    if val.nil?
      if mandatory == "Y"
        if !relevance.include? "NAOK" # skip logic
          binding.pry
        else
          @check_skip = true
        end
      end
    end
  end
end
