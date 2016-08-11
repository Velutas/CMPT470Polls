require 'test_helper'

# Tests based on tutorial at railstutorial.org
# (https://www.railstutorial.org/book/account_activation_password_reset)
class UserTest < ActiveSupport::TestCase
    
    def setup
        @user = User.new(name: "Example User", email: "user@example.com",
        password: "foobar", password_confirmation: "foobar")
    end
    
    test "authenticated? should return false for a user with nil digest" do
        assert_not @user.authenticated?(:remember, '')
    end

end
