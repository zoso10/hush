# frozen_string_literal: true

require_relative "../sentiment"

RSpec.describe Hush::Sentiment do
  let(:nice_statement) do
    "you're doing great buddy; keep up the good work. i'm proud of you."
  end
  let(:mean_statement) do
    "hey, you really suck!"
  end
  let(:neutral_statement) do
    "i can see the good and bad"
  end

  describe "#nice?" do
    it "returns true for a nice statement" do
      expect(described_class.new(nice_statement)).to be_nice
    end

    it "returns false for a mean statement" do
      expect(described_class.new(mean_statement)).not_to be_nice
    end

    it "returns false for a neutral statement" do
      expect(described_class.new(neutral_statement)).not_to be_nice
    end
  end

  describe "#mean?" do
    it "returns true for a mean statement" do
      expect(described_class.new(mean_statement)).to be_mean
    end

    it "returns false for a nice statement" do
      expect(described_class.new(nice_statement)).not_to be_mean
    end

    it "returns false for a neutral statement" do
      expect(described_class.new(neutral_statement)).not_to be_mean
    end
  end

  describe "#neutral" do
    it "returns true for a neutral statement" do
      expect(described_class.new(neutral_statement)).to be_neutral
    end
  end
end
