class SquadronsController < ApplicationController
  def index
    @squadrons = Squadron.all
  end
  
  def show
    @squadron = Squadron.find(params[:id])
  end
  
  def new
    @squadron = Squadron.new
  end
  
  def create
    @squadron = Squadron.new(params[:squadron])
    if @squadron.save
      attach_image(@squadron,params["attachfile"],"#{@squadron.name} squadron")
      flash[:notice] = "Successfully created squadron."
      redirect_to @squadron
    else
      render :action => 'new'
    end
  end
  
  def edit
    @squadron = Squadron.find(params[:id])
  end
  
  def update
    @squadron = Squadron.find(params[:id])
    if @squadron.update_attributes(params[:squadron])
      attach_image(@squadron,params["attachfile"],"#{@squadron.name} squadron")
      flash[:notice] = "Successfully updated squadron."
      redirect_to @squadron
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @squadron = Squadron.find(params[:id])
    @squadron.destroy
    flash[:notice] = "Successfully destroyed squadron."
    redirect_to squadrons_url
  end
end
