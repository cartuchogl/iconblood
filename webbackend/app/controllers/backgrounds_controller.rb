class BackgroundsController < ApplicationController
  def index
    @backgrounds = Background.all
  end
  
  def show
    @background = Background.find(params[:id])
  end
  
  def new
    @background = Background.new
  end
  
  def create
    @background = Background.new(params[:background])
    if @background.save
      flash[:notice] = "Successfully created background."
      redirect_to @background
    else
      render :action => 'new'
    end
  end
  
  def edit
    @background = Background.find(params[:id])
  end
  
  def update
    @background = Background.find(params[:id])
    if @background.update_attributes(params[:background])
      flash[:notice] = "Successfully updated background."
      redirect_to @background
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @background = Background.find(params[:id])
    @background.destroy
    flash[:notice] = "Successfully destroyed background."
    redirect_to backgrounds_url
  end
end
