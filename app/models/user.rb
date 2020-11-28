class User < ApplicationRecord
    has_secure_password # Adds password functionality for each User

    # User validation
    validates :username, presence: true,
                         length: { minimum: 6, maximum: 20 },
                         uniqueness: { case_sensitive: false }

    validates :password, presence: true,
                         length: { minimum: 8, maximum: 30 }

    validates :email, presence: true, 
                      format: { with: URI::MailTo::EMAIL_REGEXP }, 
                      uniqueness: { case_sensitive: false }

    before_save :downcase_username

    # Each user has many accounts, which has many transactions
    has_many :accounts
    #has_many :transactions, through: :accounts
    has_many :sent_transactions, through: :accounts
    has_many :received_transactions, through: :accounts
    has_many :transactions, through: :accounts

    # This function is taken from the LGT and from https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
    def User.digest(passphrase)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(passphrase, cost: cost)
    end

    private

        # Method that makes the username all lower case before saving to the database
        def downcase_username() 
            self.username = username.downcase
        end
        
end
