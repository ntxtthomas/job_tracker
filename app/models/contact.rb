class Contact < ApplicationRecord
  belongs_to :company
  has_many :interactions, dependent: :destroy
end
