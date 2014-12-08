class FileUploadsController < ApplicationController
  # before_filter :verify_create_params, :only => :create
  def create

    unless file_params
      redirect_to :action => :new
      return
    end

    Rails.logger.info("SHOULD NOT BE HERE")
    @fileupload = FileUpload.new(file_params)

    if @fileupload.save
      flash[:success] = "#{@fileupload.name} uploaded successfully !!!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def new
    @fileupload = FileUpload.new
  end

  def show
    @fileupload = FileUpload.find(params[:id])
  end

  def download
    @upload = FileUpload.find(params[:id])
    send_file @upload.path, type: @upload.content_type, disposition: 'attachment'
  end

  # get home page
  def index
    @fileupload = FileUpload.all
  end

  def destroy
    @fileupload = FileUpload.find(params[:id])
    if @fileupload.destroy
      flash[:success] = "File successfully removed from our system"
    else
      flash[:error] = "Something went wrong while deleting your file"
    end
    redirect_to root_url
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
      Rails.logger.info("00349340340------")
      return false
    end

  end
end
