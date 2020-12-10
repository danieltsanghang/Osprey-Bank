class User < ApplicationRecord
    has_secure_password # Adds password functionality for each User

    # User validation
    validates :username, presence: true,
                         length: { minimum: 6, maximum: 20 },
                         uniqueness: { case_sensitive: false }

    validates :password, presence: true,
                         length: { minimum: 8, maximum: 30 },
                         on: [:create, :password_change]

    validates :email, presence: true,
                      format: { with: URI::MailTo::EMAIL_REGEXP },
                      uniqueness: { case_sensitive: false }

    validates :DOB, presence: true

    validates :fname, presence: true

    validates :lname, presence: true

    validates :address, presence: true

    validates :phoneNumber, presence: true,
                            numericality: true,
                            length: { minimum: 9, maximum: 15 }

    before_save :downcase_username # Downcase username
    before_save :default_values # Set default admin value to false if it does not exist

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

end
