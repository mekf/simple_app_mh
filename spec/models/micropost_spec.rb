require 'spec_helper'

describe Micropost do

  #q should I do this?
  # before(:all) do
  #   @user = FactoryGirl.create(:user)
  # end

  let(:user) { FactoryGirl.create(:user) }
  before do
    # @micropost = Micropost.new(content: Faker::Lorem.sentence, user_id: user.id)
    @micropost = user.microposts.new(content: Faker::Lorem.sentence)
    # @micropost = FactoryGirl.create(:micropost, user_id: user.id)
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  describe "accessible attributes" do
    it "should not allow manual access to user_id" do
      expect do
        # FactoryGirl.build(:micropost, user_id: user.id)
        Micropost.new(content: Faker::Lorem.sentence, user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not presence" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
end
