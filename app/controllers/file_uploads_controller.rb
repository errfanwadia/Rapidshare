class FileUploadsController < ApplicationController
  # before_filter :verify_create_params, :only => :create
  before_action :check_signed_in

  before_action :check_authorized, only: [:show, :destroy, :download]

  def create

    unless file_params
      redirect_to action: "index" and return
      return
    end

    @fileupload = current_user.file_uploads.new(file_params)

    if @fileupload.save
      flash[:success] = "#{@fileupload.name} uploaded successfully !!!"
      redirect_to action: "index" and return
    else
      flash[:error] = "#{@fileupload.name} upload failed !!!"
      render 'new'
    end
  end

  def new
    @fileupload = FileUpload.new
  end

  def show
    @fileupload = current_user.file_uploads.find(params[:id])
  end

  def download
    @upload = current_user.file_uploads.find(params[:id])
    send_file @upload.path, type: @upload.content_type, disposition: 'attachment'
  end

  # get home page
  def index
    @fileupload = current_user.file_uploads.all
  end

  def destroy
    @fileupload = current_user.file_uploads.find(params[:id])
    if @fileupload.destroy
      flash[:success] = "File successfully removed from our system"
    else
      flash[:error] = "Something went wrong while deleting your file"
    end
    redirect_to action: "index" and return
  end

  # # # to map
  # private
  # def verify_create_params
  #   render 'new' if params.has_key?(:file_upload)
  # end

  private
  def file_params
    if (params.has_key?(:file_upload))
      params.require(:file_upload).permit(:file)
    else
      @fileupload = FileUpload.new
      return false
    end

  end
end
