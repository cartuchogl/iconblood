require File.dirname(__FILE__) + '/../spec_helper'
 
describe PlayersController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Player.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    (a = Player.new).stub(:save=>false)
    Player.should_receive(:new).and_return(a)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    (a = Player.first).stub(:save=>true)
    Player.should_receive(:new).and_return(a)
    post :create
    response.should redirect_to(player_url(assigns[:player]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Player.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    (a = Player.first).stub(:save=>false)
    Player.stub(:find=>a)
    put :update, :id => Player.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    (a = Player.first).stub(:save=>true)
    Player.stub(:find=>a)
    put :update, :id => Player.first
    response.should redirect_to(player_url(assigns[:player]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    player = Player.first
    delete :destroy, :id => player
    response.should redirect_to(players_url)
    Player.exists?(player.id).should be_false
  end
end
