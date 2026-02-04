class NormalizeOpportunityStatuses < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE opportunities
      SET status = 'applied'
      WHERE status = 'submitted';

      UPDATE opportunities
      SET status = 'interviewing'
      WHERE status IN ('under_review', 'phone_screen', 'interview', 'responded', 'offer');

      UPDATE opportunities
      SET status = 'closed'
      WHERE status = 'withdrawn';
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
