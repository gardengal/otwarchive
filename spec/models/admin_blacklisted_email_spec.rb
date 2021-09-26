require 'spec_helper'

describe AdminBlacklistedEmail, :ready do

  it "can be created" do
    expect(create(:admin_banned_email)).to be_valid
  end

  context "invalid" do
    let(:banned_without_email) {build(:admin_banned_email, email: nil)}
    it 'is invalid without an email' do
      expect(banned_without_email.save).to be_falsey
      expect(banned_without_email.errors[:email]).not_to be_empty
    end
  end

  context "uniqueness" do
    let(:existing_email) {create(:admin_banned_email, email: "foobar@gmail.com")}

    it "is invalid if email is not unique" do
      expect(build(:admin_banned_email, email: existing_email.email)).to be_invalid
    end
  end
    
  context "banned emails" do
    before(:each) do
      @existing_email = FactoryBot.create(:admin_banned_email, email: "foobar@gmail.com")
      @existing_email2 = FactoryBot.create(:admin_banned_email, email: "foo@bar.com")
    end
    
    it "match themselves" do
      expect(AdminBlacklistedEmail.is_banned?("foobar@gmail.com"))
      expect(AdminBlacklistedEmail.is_banned?("foo@bar.com"))
    end
    
    it "match variants" do
      expect(AdminBlacklistedEmail.is_banned?("FOO@bar.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("foo+baz@bar.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("FOO@BAR.COM")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("FOOBAR@gmail.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("foobar+baz+bat@gmail.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("foo.bar@gmail.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("f.o.o.bar@gmail.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("foobar@googlemail.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("foobar@GOOGLEMAIL.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("fo.ob.ar@googlemail.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("foobar+baz@googlemail.com")).to be_truthy
      expect(AdminBlacklistedEmail.is_banned?("FOOBAR@googlemail.com")).to be_truthy      
    end
    
    it "do not match other emails" do
      expect(AdminBlacklistedEmail.is_banned?("something_else@bar.com")).to be_falsey
      expect(AdminBlacklistedEmail.is_banned?("foo@gmail.com")).to be_falsey
      expect(AdminBlacklistedEmail.is_banned?("something_else@gmail.com")).to be_falsey
      expect(AdminBlacklistedEmail.is_banned?("foo.f.o.o@gmail.com")).to be_falsey
    end
  end
end
