# Base code and digestions implemented based on code at railstutorial.org chapters 6, 7, 8, 9, 10
# Basic fields: https://www.railstutorial.org/book/modeling_users
# Digestions + tokens: https://www.railstutorial.org/book/log_in_log_out
# Activation Digest: https://www.railstutorial.org/book/account_activation_password_reset

class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    before_create :create_activation_digest
    validates :name, presence: true, length: { maximum: 50 },
        uniqueness: { case_sensitive: true }
    validates :email, presence: true, length: {maximum: 255 }, 
        format: { with: /\A[\w+\.]+@[a-z\d\-.]+\.[a-z]+\z/i }, 
        uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
    attr_accessor :remember_token, :activation_token, :reset_token

    has_many :friends, dependent: :destroy
    has_many :messages, dependent: :destroy

    enum user_type: { 
        normal: 0, 
        moderator: 1, 
        admin: 2 
    } 
    enum contact_visibility: { 
        contacts_public: 0, 
        contacts_friends: 1, 
        contacts_private: 2 
    }
    enum response_visibility: { 
        responses_public: 0, 
        responses_friends: 1, 
        responses_private: 2 
    }

    class << self
        # Returns the hash digest of the given string.
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ?   BCrypt::Engine::MIN_COST :
                                                                                            BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end

        # Returns a random token.
        def new_token
            SecureRandom.urlsafe_base64
        end
    end

    # Sourced from https://www.railstutorial.org/book/account_activation_password_reset#code-account_activation_email
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end

    # Sourced from https://www.railstutorial.org/book/account_activation_password_reset#code-account_activation_email
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    # Sourced from https://www.railstutorial.org/book/account_activation_password_reset#code-account_activation_email
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
    end

    # Sourced from https://www.railstutorial.org/book/account_activation_password_reset#code-account_activation_email
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    # Forgets a user.
    def forget
      update_attribute(:remember_digest, nil)
    end

    # Sourced from https://www.railstutorial.org/book/account_activation_password_reset
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    private
        # Creates and assigns the activation token and digest.
        def create_activation_digest
            self.activation_token  = User.new_token
            self.activation_digest = User.digest(activation_token)
        end

end