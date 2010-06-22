require File.dirname(__FILE__) + '/../spec_helper'
 
describe UnitOptionsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => UnitOption.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = UnitOption.new).stub(:save=>false)
    UnitOption.should_receive(:new).and_return(a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = UnitOption.first).stub(:save=>true)
    UnitOption.should_receive(:new).and_return(a)
    post :create
    response.should redirect_to(unit_option_url(assigns[:unit_option]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => UnitOption.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    (a = UnitOption.first).stub(:save=>false)
    UnitOption.stub(:find=>a)
    put :update, :id => UnitOption.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    (a = UnitOption.first).stub(:save=>true)
    UnitOption.stub(:find=>a)
    put :update, :id => UnitOption.first
    response.should redirect_to(unit_option_url(assigns[:unit_option]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    unit_option = UnitOption.first
    delete :destroy, :id => unit_option
    response.should redirect_to(unit_options_url)
    UnitOption.exists?(unit_option.id).should be_false
  end
end
