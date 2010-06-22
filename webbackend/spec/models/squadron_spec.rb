require File.dirname(__FILE__) + '/../spec_helper'

describe Squadron do
  it "should be valid" do
    Squadron.new.should be_valid
  end
end
