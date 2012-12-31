# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#

require 'spec_helper'

describe User do
  # before do
  #   @user = User.new( all relevant hashes )
  # end

  before do
    @user = FactoryGirl.build(:user)
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) } #10.9
  it { should respond_to(:feed) } #10.38
  it { should respond_to(:relationships) } #11.3
  it { should respond_to(:followed_users) } #11.11
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }

  it { should be_valid }
  it { should_not be_admin }

  describe "when user is set to admin" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin }
  end

  describe "when name is not presence" do
    before { @user.name = "" }
    it { should_not be_valid }
  end

  describe "when email is not presence" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

   describe "when email format is invalid" do
    it "should be invalid" do
      # addresses = %w[user@foo,com user_at_foo.org example.user@foo.
      #                foo@bar_baz.com foo@bar+baz.com]

      addresses = invalid_emails(addresses) #utilities.rb

      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      #addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

      addresses = valid_emails(addresses) #utilities.rb

      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  #why does it fail if the user is generated by FactoryGirl
  describe "user with same email" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "user with mixed case email" do
    let(:mixed_case_email) { "Foo@EXAMPLE.com" }

    it "should be saved as lower case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end

  describe "when password is blank" do
    before { @user.password = @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  describe "when password mismatch" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when the password_confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "authenticate user" do
    before { @user.save }
    let(:queried_user) { User.find_by_email(@user.email) }

    describe "user with valid password" do
      it { should == queried_user.authenticate(@user.password) }
    end

    describe "user with invalid password" do
      let(:invalid_pwd_user) { queried_user.authenticate("invalid") }

      it { should_not == invalid_pwd_user }
      specify { invalid_pwd_user.should be_false }
    end

    describe "user with short password" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      #it { should be_invalid }
      it { should_not be_valid }
    end
  end

  describe "remember token" do
    before { @user.save }

    its(:remember_token) { should_not be_blank }
    #it { @user.remember_token.should_not be_blank }
  end

  describe "microposts associations" do
    before { @user.save }
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end

    it "should be arranged newer > older" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.dup #q research more about this
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |m|
        Micropost.find_by_id(m.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "and unfollowing" do
      before {@user.unfollow!(other_user) }
      
      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
