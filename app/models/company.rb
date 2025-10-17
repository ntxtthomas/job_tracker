class Company < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :interactions, dependent: :destroy
  has_many :opportunities, dependent: :destroy
end
