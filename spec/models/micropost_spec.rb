require 'spec_helper'

describe Micropost do

  #q should I do this?
  # before(:all) do
  #   @user = FactoryGirl.create(:user)
  # end

  let(:user) { FactoryGirl.create(:user) }
  before do
    # @micropost = Micropost.new(content: Faker::Lorem.sentence, user_id: user.id)
    # @micropost = user.microposts.build(content: Faker::Lorem.sentence)
    @micropost = user.microposts.new(content: Faker::Lorem.sentence)
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  describe "accessible attributes" do
    it "should not allow manual access to user_id" do
      expect do
        #q FactoryGirl is not working in this case.
        # FactoryGirl.build(:micropost, user_id: user.id)

        Micropost.new(content: Faker::Lorem.sentence, user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not presence" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "when is blank" do
    before { @micropost.content = "" }
    it { should_not be_valid }
  end

  describe "when is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end
