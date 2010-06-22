require File.dirname(__FILE__) + '/../spec_helper'

describe Faction do
  it "should be valid" do
    Faction.new.should be_valid
  end
end
