require "csv"

class SurveyStructure < Array
  attr_reader :headers

  def initialize file, opts = {}
    @csv_opts = {headers: true, col_sep: "\t", quote_char: "|"}.merge(opts)
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

  def next_row_is_sq? row, ary
    next_row = find(row.index + 1)
    if next_row.nil? or !next_row.is_a_sq?
      ary
    else
      ary.push next_row
      next_row_is_sq? next_row, ary
    end
  end

  def prev_row_is_q? row
    prev_row = find(row.index - 1)
    if prev_row.is_a_q?
      return prev_row
    else
      prev_row_is_q? prev_row
    end
  end

  private

  def read_file file
    CSV.foreach(file, @csv_opts).with_index(0) do |r, idx|
      row = SurveyRow.new()
      row["index"] = idx
      binding.pry if r["type/scale"] == ";"
      r.first(5).each do |h, r|
        row[h] = r
      end
      self.push row
    end
  end
end
