require File.dirname(__FILE__) + '/../spec_helper'

describe SquadronUnit do
  it "should be valid" do
    SquadronUnit.new.should be_valid
  end
end
