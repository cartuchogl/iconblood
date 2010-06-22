require File.dirname(__FILE__) + '/../spec_helper'
 
describe SquadronsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Squadron.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = Squadron.new).stub(:save=>false)
    Squadron.should_receive(:new).and_return(a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = Squadron.first).stub(:save=>true)
    Squadron.should_receive(:new).and_return(a)
    post :create
    response.should redirect_to(squadron_url(assigns[:squadron]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Squadron.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    (a = Squadron.first).stub(:save=>false)
    Squadron.stub(:find=>a)
    put :update, :id => Squadron.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    (a = Squadron.first).stub(:save=>true)
    Squadron.stub(:find=>a)
    put :update, :id => Squadron.first
    response.should redirect_to(squadron_url(assigns[:squadron]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    squadron = Squadron.first
    delete :destroy, :id => squadron
    response.should redirect_to(squadrons_url)
    Squadron.exists?(squadron.id).should be_false
  end
end
