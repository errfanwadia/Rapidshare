class AddDetailsToFileUpload < ActiveRecord::Migration
  def change
    add_column :file_uploads, :name, :string
    add_column :file_uploads, :size, :integer
    add_column :file_uploads, :content_type, :string
    add_column :file_uploads, :path, :string
  end
end
