module MildredErrors
  class DuplicateRowError < StandardError
    def initialize msg = "Multiple rows with the same question text"
      super
    end
  end

  class QuestionTypeMismatchError < StandardError
    def initialize msg = ""
      msg = "Question-type specific method called improperly: " + msg
      super
    end
  end
end
