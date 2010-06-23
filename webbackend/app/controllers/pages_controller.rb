class PagesController < ApplicationController
  before_filter :check_background
  
  def index
    @pages = @background ? @background.pages : Page.all
  end
  
  def show
    @page = Page.find(params[:id])
  end
  
  def new
    @page = Page.new
    if @background
      @page.background_id = @background.id
    end
  end
  
  def create
    @page = Page.new(params[:page])
    if @page.save
      attach_image(@page,params["attachfile"],"#{@page.position} his page")
      flash[:notice] = "Successfully created page."
      if @background
        redirect_to background_page_path(@background,@page)
      else
        redirect_to @page
      end
    else
      render :action => 'new'
    end
  end
  
  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      attach_image(@page,params["attachfile"],"#{@page.position} his page")
      flash[:notice] = "Successfully updated page."
      if @background
        redirect_to background_page_path(@background,@page)
      else
        redirect_to @page
      end
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    flash[:notice] = "Successfully destroyed page."
    if @background
      redirect_to background_pages_path(@background)
    else
      redirect_to pages_url
    end
  end
  
  private
  def check_background
    if params[:background_id]
      @background = Background.find(params[:background_id])
    else
      # redirect_to backgrounds_path, :notice => 'Background not found'
    end
  end
end
