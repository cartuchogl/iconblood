require File.dirname(__FILE__) + '/../spec_helper'

describe UnitOption do
  it "should be valid" do
    UnitOption.new.should be_valid
  end
end
