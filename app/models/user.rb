class User < ApplicationRecord
    has_secure_password # Adds password functionality for each User

    # User validations
    validates :username, presence: true,
                         length: { minimum: 6, maximum: 20, message: "must be 6-20 characters long" },
                         uniqueness: { case_sensitive: false, message: "taken!" }

    validates :password, presence: true,
                         length: { minimum: 8, maximum: 30, message: "must be between 8-30 characters long!" },
                         on: [:create, :password_change] # Context for password change so no errors occur when editing user account without changing password

    validates :email, presence: true,
                      format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be valid" }, # Email regular expression validation
                      uniqueness: { case_sensitive: false }

    validates :DOB, presence: true
    validate :validate_age

    # Min/max first and last name length according to ISO IEC 7813, further reference: https://en.wikipedia.org/wiki/ISO/IEC_7813
    validates :fname, presence: true,
                      length: { minimum: 2, maximum: 26, message: "must be 2-26 characters long"}

    validates :lname, presence: true,
                      length: { minimum: 2, maximum: 26, message: "must be 2-26 characters long"}

    validates :address, presence: true,
                        length: { minimum: 5, maximum: 150, message: "must be 5-150 characters long"}

    validates :phoneNumber, presence: true,
                            numericality: { greater_than: 0, message: "cannot be a negative number"},
                            length: { minimum: 9, maximum: 15, message: "must be 9-15 digits long" }

    before_save :downcase_username
    before_save :default_values

    # Model relationships:
    # Each user has many accounts, which has many transactions
    has_many :accounts
    has_many :sent_transactions, through: :accounts
    has_many :received_transactions, through: :accounts

    # This function is taken from the LGT and from https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
    def User.digest(passphrase)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(passphrase, cost: cost)
    end

    # Function used to generate CSV file of users
    def self.export_csv(users_to_export)
        attributes = ['created_at', 'id', 'username', 'fname', 'lname', 'email', 'DOB', 'phoneNumber', 'address'] # Attributes from the User model
        headers = ['Date', 'ID', 'Username', 'First Name', 'Last Name', 'Email', 'DOB', 'Phone Number', 'Address'] # Headers for the CSV file
        CSV.generate(headers: true) do |csv|
            csv << headers # Append the headers to the CSV files to serve as 'titles'
            users_to_export.each do |user|
                # For each user, add the necessary attributes to the CSV file as a row
                csv << user.attributes.values_at(*attributes)
          end
        end
    end

    private

        # Method that makes the username all lower case before saving to the database
        def downcase_username()
            self.username = username.downcase
        end

        # Method that sets the default admin attribute to false
        def default_values
            self.isAdmin ||= false
        end

        def validate_age
            if(self[:DOB].nil? || self[:DOB] > 18.years.ago)
                errors.add(:DOB, "you must be atleast 18 years old!")
            end
        end

end
