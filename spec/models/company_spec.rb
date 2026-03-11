require "rails_helper"

RSpec.describe Company, type: :model do
  describe "validations" do
    it "validates name presence" do
      company = Company.new(name: nil, company_type: "Product")

      expect(company).not_to be_valid
      expect(company.errors[:name]).to include("can't be blank")
    end

    it "validates name uniqueness case-insensitively" do
      Company.create!(name: "Acme Corp", company_type: "Product")
      duplicate = Company.new(name: "acme corp", company_type: "Product")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
    end

    it "normalizes whitespace in name before validation" do
      company = Company.new(name: "  New   Co  ", company_type: "Product")

      company.validate

      expect(company.name).to eq("New Co")
    end
  end
end
