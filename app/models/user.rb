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

    private

        # Method that makes the username all lower case before saving to the database
        def downcase_username() 
            self.username = username.downcase
        end
        
end
