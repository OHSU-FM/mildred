require "csv"
require_relative "survey_row"
require_relative "mildred_error"

class SurveyStructure < Array
  attr_reader :headers

  def initialize file
    read_file file
  end

  def find *ids
    expects_array = ids.first.kind_of? Array
    return ids.first if expects_array && ids.first.empty?

    ids = ids.flatten.compact.uniq

    case ids.size
    when 0
      raise MildredErrors::RowNotFound, "Can't find without an index"
    when 1
      result = select{|e| e["index"] == ids.first}
      expects_array ? result : result.first
    else
      select{|e| ids.include? e["index"] }
    end
  end

  # @return [Array[SurveyRow]]
  def find_by args
    case args.count
    when 0
      raise MildredErrors::RowNotFound, "Can't find_by without arguments"
    when 1
      k, v = args.first
      select{|e| e[k] == v}
    else
      candidates = self
      args.each do |arg|
        k, v = arg
        candidates = candidates.select{|c| c[k] == v }
      end
      candidates
    end
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

  private

  def get_next_row row
    self[row["index"] + 1]
  end

  def next_row_is_sq? row, ary
    next_row = get_next_row row
    if is_sq? next_row["text"]
      ary.push next_row
      next_row_is_sq? next_row, ary
    else
      ary
    end
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

    CSV.foreach(file, col_sep: ",", quote_char: "|").with_index(1) do |r, idx|
      if first_run
        first_run = false
        @headers = r.first(5)
        next
      end

      row = SurveyRow.new
      row["index"] = idx - 1
      r.first(5).each_with_index do |e, i|
        row[@headers[i]] = e
      end
      self.push row
    end
  end
end
