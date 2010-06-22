require File.dirname(__FILE__) + '/../spec_helper'
 
describe BackgroundsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Background.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = Background.new).stub(:save=>false)
    Background.should_receive(:new).and_return(a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = Background.first).stub(:save=>true)
    Background.should_receive(:new).and_return(a)
    post :create
    response.should redirect_to(background_url(assigns[:background]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Background.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    (a = Background.first).stub(:save=>false)
    Background.stub(:find=>a)
    put :update, :id => Background.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    (a = Background.first).stub(:save=>true)
    Background.stub(:find=>a)
    put :update, :id => Background.first
    response.should redirect_to(background_url(assigns[:background]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    background = Background.first
    delete :destroy, :id => background
    response.should redirect_to(backgrounds_url)
    Background.exists?(background.id).should be_false
  end
end
