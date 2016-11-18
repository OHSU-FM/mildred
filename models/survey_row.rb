require "active_model"
require "active_model/associations"
require "ostruct"

class SurveyRow < OpenStruct
  binding.pry
  include ActiveModel::Model
  include ActiveModel::Associations

  belongs_to :survey_structure
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
    row = get_row_with_text q_text
    next_row_is_sq? row, children
  end

  def parent q_text
    unless is_sq? q_text
      raise MildredErrors::QuestionTypeMismatchError.new("sq on q")
    end

    row = get_row_with_text q_text
    prev_row_is_q? row
  end

  def question_class q_text
    get_row_with_text(q_text)["class"]
  end

end
