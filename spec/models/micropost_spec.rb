require 'spec_helper'

describe Micropost do

  #q should I do this?
  # before(:all) do
  #   @user = FactoryGirl.create(:user)
  # end

  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is wrong!
    # @micropost = Micropost.new(content: Faker::Lorem.sentence, user_id: user.id)
    @micropost = FactoryGirl.create(:micropost, user_id: user.id)
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
end
