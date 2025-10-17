class ChangeContactIdToOptionalInInteractions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :interactions, :contact_id, true
  end
end
