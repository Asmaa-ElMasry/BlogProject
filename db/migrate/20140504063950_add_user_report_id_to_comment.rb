class AddUserReportIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :user_report_id, :integer
  end
end
