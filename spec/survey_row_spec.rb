require "spec_helper"

describe SurveyRow do
  describe "generic row" do
    before do
      @row = row_from_fixture("generic_row")
    end

    it "has attr readers" do
      @row.each do |key, value|
        expect(@row.send(key.to_sym)).to eq value
      end
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
  end
end
