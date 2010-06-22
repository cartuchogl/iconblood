require File.dirname(__FILE__) + '/../spec_helper'
 
describe FactionsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Faction.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = Faction.new).stub(:save=>false)
    Faction.should_receive(:new).and_return(a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = Faction.first).stub(:save=>true)
    Faction.should_receive(:new).and_return(a)
    post :create
    response.should redirect_to(faction_url(assigns[:faction]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Faction.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    (a = Faction.first).stub(:save=>false)
    Faction.stub(:find=>a)
    put :update, :id => Faction.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    (a = Faction.first).stub(:save=>true)
    Faction.stub(:find=>a)
    put :update, :id => Faction.first
    response.should redirect_to(faction_url(assigns[:faction]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    faction = Faction.first
    delete :destroy, :id => faction
    response.should redirect_to(factions_url)
    Faction.exists?(faction.id).should be_false
  end
end
