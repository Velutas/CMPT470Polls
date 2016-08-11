require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # Set up based on instructions at https://www.railstutorial.org/book/account_activation_password_reset 
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Activate your account", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  # Set up based on instructions at https://www.railstutorial.org/book/account_activation_password_reset 
  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Reset your password", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "friend_request" do
    mail = UserMailer.friend_request
    assert_equal "Friend request", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "friend_suggestion" do
    mail = UserMailer.friend_suggestion
    assert_equal "Friend suggestion", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "private_message" do
    mail = UserMailer.private_message
    assert_equal "Private message", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
