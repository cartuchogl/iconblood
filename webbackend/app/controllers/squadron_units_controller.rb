class SquadronUnitsController < ApplicationController
  def index
    @squadron_units = SquadronUnit.all
  end
  
  def show
    @squadron_unit = SquadronUnit.find(params[:id])
  end
  
  def new
    @squadron_unit = SquadronUnit.new
  end
  
  def create
    @squadron_unit = SquadronUnit.new(params[:squadron_unit])
    if @squadron_unit.save
      flash[:notice] = "Successfully created squadron unit."
      redirect_to @squadron_unit
    else
      render :action => 'new'
    end
  end
  
  def edit
    @squadron_unit = SquadronUnit.find(params[:id])
  end
  
  def update
    @squadron_unit = SquadronUnit.find(params[:id])
    if @squadron_unit.update_attributes(params[:squadron_unit])
      flash[:notice] = "Successfully updated squadron unit."
      redirect_to @squadron_unit
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @squadron_unit = SquadronUnit.find(params[:id])
    @squadron_unit.destroy
    flash[:notice] = "Successfully destroyed squadron unit."
    redirect_to squadron_units_url
  end
end
