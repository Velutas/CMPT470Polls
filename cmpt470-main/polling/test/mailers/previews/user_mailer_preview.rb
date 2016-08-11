# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  # Set up based on instructions at https://www.railstutorial.org/book/account_activation_password_reset
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  # Set up based on instructions at https://www.railstutorial.org/book/account_activation_password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/friend_request
  def friend_request
    UserMailer.friend_request
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/friend_suggestion
  def friend_suggestion
    UserMailer.friend_suggestion
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/private_message
  def private_message
    UserMailer.private_message
  end

end
