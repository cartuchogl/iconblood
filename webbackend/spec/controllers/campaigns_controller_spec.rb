require File.dirname(__FILE__) + '/../spec_helper'
 
describe CampaignsController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Campaign.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = Campaign.new).stub(:save=>false)
    Campaign.should_receive(:new).and_return(a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = Campaign.first).stub(:save=>true)
    Campaign.should_receive(:new).and_return(a)
    post :create
    response.should redirect_to(campaign_url(assigns[:campaign]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Campaign.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    (a = Campaign.first).stub(:save=>false)
    Campaign.stub(:find=>a)
    put :update, :id => Campaign.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    (a = Campaign.first).stub(:save=>true)
    Campaign.stub(:find=>a)
    put :update, :id => Campaign.first
    response.should redirect_to(campaign_url(assigns[:campaign]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    campaign = Campaign.first
    delete :destroy, :id => campaign
    response.should redirect_to(campaigns_url)
    Campaign.exists?(campaign.id).should be_false
  end
end
