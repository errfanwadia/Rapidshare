class FileUpload < ActiveRecord::Base

  before_validation :process
  before_create :upload_file

  attr_accessor :file

  validates :file, presence: true

  def process
    @uploaded_object = self.file
    filename = @uploaded_object.original_filename
    self.name = sanitize_filename(filename)
    self.size = @uploaded_object.tempfile.size
    self.content_type = @uploaded_object.content_type
    self.path = Rails.root.join('uploads', self.name).to_s
  end

  private
  def sanitize_filename(filename)
    basename = File.basename(filename, '.*').gsub(/\s/, '_')
    extension = File.extname(filename)
    timestamp = Time.now.seconds_since_midnight.to_i.to_s
    # puts basename + "_" + timestamp + extension
    basename + "_" + timestamp + extension
  end

  def upload_file
    File.open(self.path, 'wb') do |file|
      file.write(@uploaded_object.read)
    end
  end

  def destroy_uploaded_file
    File.delete(self.path)
  end
end
