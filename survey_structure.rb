require "csv"
require_relative "mildred_error"

class SurveyStructure < Array
  attr_reader :headers

  def initialize file
    read_file file
  end

  def [] idx
    select{|e| e["index"] == idx}.first
  end

  def meta
    select{|e| ["S", "SL"].include? e["class"] }
  end

  def groups
    select{|e| e["class"] == "G" }
  end

  def questions
    select{|e| ["Q", "SQ"].include? e["class"] }
  end

  def only_questions
    select{|e| e["class"] == "Q" }
  end

  def subquestions
    select{|e| e["class"] == "SQ" }
  end

  def answers
    select{|e| e["class"] == "A" }
  end

  def is_q? q_text
    question_class(q_text) == "Q"
  end

  def is_sq? q_text
    question_class(q_text) == "SQ"
  end

  def get_children q_text
    unless is_q? q_text
      raise MildredErrors::QuestionTypeMismatchError.new("q on sq")
    end

    children = []
    row = get_row_with_text q_text
    next_row = self[row["index"] + 1]
    if is_sq? next_row["text"]
      return next_row
    else
      next_row_is_sq? next_row
    end
  end

  def get_parent_q q_text
    unless is_sq? q_text
      raise MildredErrors::QuestionTypeMismatchError.new("sq on q")
    end

    row = get_row_with_text q_text
    prev_row_is_q? row
  end

  def question_class q_text
    get_row_with_text(q_text)["class"]
  end

  def get_row_with_text q_text
    opts = select{|e| e["text"] == q_text }
    if opts.count == 1
      opts.first
    else
      raise MildredErrors::DuplicateRowError
    end
  end

  private

  def get_next_row row
    self[row["index" + 1]]
  end

  def prev_row_is_q? row
    prev_row = self[row["index"] - 1]
    if is_q? prev_row["text"]
      return prev_row
    else
      prev_row_is_q? prev_row
    end
  end

  def read_file file
    first_run = true

    CSV.foreach(file, col_sep: "\t").with_index(1) do |r, idx|
      if first_run
        first_run = false
        @headers = r.first(5)
        next
      end

      row = Hash.new
      row["index"] = idx - 1
      r.first(5).each_with_index do |e, i|
        row[@headers[i]] = e
      end
      self.push row
    end
  end
end
