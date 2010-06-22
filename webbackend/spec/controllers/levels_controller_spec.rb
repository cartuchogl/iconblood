require File.dirname(__FILE__) + '/../spec_helper'
 
describe LevelsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Level.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = Level.new).stub(:save=>false)
    Level.should_receive(:new).and_return(a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = Level.first).stub(:save=>true)
    Level.should_receive(:new).and_return(a)
    post :create
    response.should redirect_to(level_url(assigns[:level]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Level.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    (a = Level.first).stub(:save=>false)
    Level.stub(:find=>a)
    put :update, :id => Level.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    (a = Level.first).stub(:save=>true)
    Level.stub(:find=>a)
    put :update, :id => Level.first
    response.should redirect_to(level_url(assigns[:level]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    level = Level.first
    delete :destroy, :id => level
    response.should redirect_to(levels_url)
    Level.exists?(level.id).should be_false
  end
end
