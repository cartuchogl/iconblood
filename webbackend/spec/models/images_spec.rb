require File.dirname(__FILE__) + '/../spec_helper'

describe Images do
  it "should be valid" do
    Images.new.should be_valid
  end
end
