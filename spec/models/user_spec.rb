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
#

require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Tester", email: "tester@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

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
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

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
end
