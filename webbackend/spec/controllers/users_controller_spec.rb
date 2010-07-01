require File.dirname(__FILE__) + '/../spec_helper'
 
describe UsersController do
  fixtures :all
  integrate_views
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = User.first).stub(:'valid?'=>false)
    User.stub(:find=>a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = User.first).stub(:'valid?'=>true)
    User.stub(:new=>a)
    post :create
    response.should redirect_to(root_url)
    session['user_id'].should == assigns['user'].id
  end
end
