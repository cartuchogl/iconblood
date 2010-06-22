require File.dirname(__FILE__) + '/../spec_helper'

describe Background do
  it "should be valid" do
    Background.new.should be_valid
  end
end
