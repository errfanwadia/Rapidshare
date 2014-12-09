class AddUserRefToFileUpload < ActiveRecord::Migration
  def change
    add_reference :file_uploads, :user, index: true
  end
end
