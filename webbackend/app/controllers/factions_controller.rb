class FactionsController < ApplicationController
  def index
    @factions = Faction.all
  end
  
  def show
    @faction = Faction.find(params[:id])
  end
  
  def new
    @faction = Faction.new
  end
  
  def create
    @faction = Faction.new(params[:faction])
    if @faction.save
      attach_image(@faction,params["attachfile"],"#{@faction.name} emblem")
      flash[:notice] = "Successfully created faction."
      redirect_to @faction
    else
      render :action => 'new'
    end
  end
  
  def edit
    @faction = Faction.find(params[:id])
  end
  
  def update
    @faction = Faction.find(params[:id])
    if @faction.update_attributes(params[:faction])
      attach_image(@faction,params["attachfile"],"#{@faction.name} emblem")
      flash[:notice] = "Successfully updated faction."
      redirect_to @faction
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @faction = Faction.find(params[:id])
    @faction.destroy
    flash[:notice] = "Successfully destroyed faction."
    redirect_to factions_url
  end
end
