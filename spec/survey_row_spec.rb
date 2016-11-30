require "spec_helper"

describe SurveyRow do
  before do
    $ss = SurveyStructure.new(from_fixture)
  end

  describe "generic row" do
    before do
      @row = row_from_fixture("generic_row")
    end

    it "has attr readers" do
      @row.each do |key, value|
        expect(@row.send(key.to_sym)).to eq value
      end
    end

    it "can reference the global survey stucture" do
      expect(@row.survey_structure).to eq $ss
    end
  end

  describe "question row" do
    before do
      @row = row_from_fixture("question_row")
    end

    it "#is_a_q?" do
      expect(@row.is_a_q?).to be_truthy
    end

    it "!#is_a_sq?" do
      expect(@row.is_a_sq?).not_to be_truthy
    end

    it "#has_children?" do
      expect(@row.has_children?).to be_truthy
    end

    it "#children" do
      @sq = row_from_fixture("subquestion_row")
      expect(@row.children).to include @sq
    end

    it "#parent" do
      expect{@row.parent}.to raise_error MildredError::QuestionTypeMismatchError
    end

    it "#answers" do
      expect(@row.answers.length).to eq 5
    end
  end

  describe "subquestion row" do
    before do
      @row = row_from_fixture("subquestion_row")
    end

    it "!#is_a_q?" do
      expect(@row.is_a_q?).not_to be_truthy
    end

    it "#is_a_sq?" do
      expect(@row.is_a_sq?).to be_truthy
    end

    it "#has_children?" do
      expect{@row.has_children?}.to raise_error MildredError::QuestionTypeMismatchError
    end

    it "#children" do
      expect{@row.children}.to raise_error MildredError::QuestionTypeMismatchError
    end

    it "#parent" do
      @q = row_from_fixture("question_row")
      expect(@row.parent).to eq @q
    end
  end
end
