class Interaction < ApplicationRecord
  belongs_to :contact, optional: true
  belongs_to :company
end
