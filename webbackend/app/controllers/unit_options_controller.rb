class UnitOptionsController < ApplicationController
  def index
    @unit_options = UnitOption.all
  end
  
  def show
    @unit_option = UnitOption.find(params[:id])
  end
  
  def new
    @unit_option = UnitOption.new
  end
  
  def create
    @unit_option = UnitOption.new(params[:unit_option])
    if @unit_option.save
      attach_image(@unit_option,params["attachfile"],"#{@unit_option.name} equip")
      flash[:notice] = "Successfully created unit option."
      redirect_to @unit_option
    else
      render :action => 'new'
    end
  end
  
  def edit
    @unit_option = UnitOption.find(params[:id])
  end
  
  def update
    @unit_option = UnitOption.find(params[:id])
    if @unit_option.update_attributes(params[:unit_option])
      attach_image(@unit_option,params["attachfile"],"#{@unit_option.name} equip")
      flash[:notice] = "Successfully updated unit option."
      redirect_to @unit_option
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @unit_option = UnitOption.find(params[:id])
    @unit_option.destroy
    flash[:notice] = "Successfully destroyed unit option."
    redirect_to unit_options_url
  end
end
