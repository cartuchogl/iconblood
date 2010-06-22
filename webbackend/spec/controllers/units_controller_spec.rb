require File.dirname(__FILE__) + '/../spec_helper'
 
describe UnitsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Unit.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = Unit.new).stub(:save=>false)
    Unit.should_receive(:new).and_return(a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = Unit.first).stub(:save=>true)
    Unit.should_receive(:new).and_return(a)
    post :create
    response.should redirect_to(unit_url(assigns[:unit]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Unit.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    (a = Unit.first).stub(:save=>false)
    Unit.stub(:find=>a)
    put :update, :id => Unit.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    (a = Unit.first).stub(:save=>true)
    Unit.stub(:find=>a)
    put :update, :id => Unit.first
    response.should redirect_to(unit_url(assigns[:unit]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    unit = Unit.first
    delete :destroy, :id => unit
    response.should redirect_to(units_url)
    Unit.exists?(unit.id).should be_false
  end
end
