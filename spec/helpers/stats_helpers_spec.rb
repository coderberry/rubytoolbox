# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatsHelpers, type: :helper do
  describe "#percentiles" do
    it "returns a hash of number distribution percentiles" do
      Factories.project "example"
      expect(helper.percentiles(:rubygems, :downloads)).to be_a(Hash)
        .and(satisfy { |h| h.keys == (0..100).to_a.map { |n| "#{n}%" } })
        .and(satisfy { |h| h.values.all? { |v| v.is_a? Numeric } })
    end
  end

  describe "#date_groups" do
    before do
      # Null values must not cause problems...
      Rubygem.create! name: "foo", downloads: 1, current_version: 1

      [2003, 2014, 2014, 2016, 2016, 2016, Time.current.year + 1].each_with_index do |year, i|
        Rubygem.create! name:             i,
                        downloads:        i,
                        current_version:  i,
                        first_release_on: Date.new(year)
      end
    end

    it "returns counts grouped by year in given column" do
      expect(helper.date_groups(:rubygems, :first_release_on)).to be == {
        2014 => 2,
        2016 => 3,
      }
    end
  end
end
