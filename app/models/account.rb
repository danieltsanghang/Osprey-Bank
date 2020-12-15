class Account < ApplicationRecord

    # Account validations
    validates :user_id, presence:true

    validates :sortCode, length: {is: 6, message: "should only be 6 digits"}, numericality: {only_number: true},
              presence:true

    validates :currency, inclusion: { in: %w(GBP EUR USD), message: "%{value} is not a supported currency"}

    before_save :default_attributes
    
    # Model relationships:
    # Each account belongs to one user only, and each account has many sent transactions and many received transactions
    belongs_to :user, :foreign_key => :user_id
    has_many :sent_transactions, :foreign_key => :sender_id, :class_name => 'Transaction'
    has_many :received_transactions, :foreign_key => :receiver_id, :class_name => 'Transaction'

    private

        def default_attributes
          # sets default values if not specified in creation of record
          default_balance
          default_currency
        end

        def default_balance
          # If no balance was provided, the default balance should be 0
          if self.balance.nil?
            self.balance = 0
          end
        end

        def default_currency
          # If no currency was provided, the default currency should be "GBP"
          if self.currency.nil?
            self.currency = "GBP"
          end
        end

        # Function used to generate CSV file of accounts
        def self.export_csv(accounts_to_export)
            attributes = ['created_at', 'id', 'user_id', 'sortCode', 'balance', 'currency'] # Attributes from Accounts model
            headers = ['Date Created', 'Account ID', 'User ID', 'Sort Code', 'Balance', 'Currency',] # Headers for the CSV file
            CSV.generate(headers: true) do |csv|
                csv << headers # Append the headers to the CSV files to serve as 'titles'
                accounts_to_export.each do |account|
                    # For each user, add the necessary attributes to the CSV file as a row
                    csv << account.attributes.values_at(*attributes)
              end
            end
        end
end
