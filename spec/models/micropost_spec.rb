require 'spec_helper'

describe Micropost do

  before(:all) do
    @user = FactoryGirl.create(:user)
  end

  before do
    # This code is wrong!
    @micropost = Micropost.new(content: Faker::Lorem.sentence, user_id: @user.id)
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
end
