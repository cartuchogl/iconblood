class EnvironmentsController < ApplicationController
  def index
    @environments = Environment.all
  end
  
  def show
    @environment = Environment.find(params[:id])
  end
  
  def new
    @environment = Environment.new
  end
  
  def create
    @environment = Environment.new(params[:environment])
    if @environment.save
      flash[:notice] = "Successfully created environment."
      redirect_to @environment
    else
      render :action => 'new'
    end
  end
  
  def edit
    @environment = Environment.find(params[:id])
  end
  
  def update
    @environment = Environment.find(params[:id])
    if @environment.update_attributes(params[:environment])
      flash[:notice] = "Successfully updated environment."
      redirect_to @environment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @environment = Environment.find(params[:id])
    @environment.destroy
    flash[:notice] = "Successfully destroyed environment."
    redirect_to environments_url
  end
end