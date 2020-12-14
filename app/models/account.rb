class Account < ApplicationRecord
    belongs_to :user, :foreign_key => :user_id
    has_many :sent_transactions, :foreign_key => :sender_id, :class_name => 'Transaction'
    has_many :received_transactions, :foreign_key => :receiver_id, :class_name => 'Transaction'

    validates :user_id, presence:true

    validates :sortCode, length: {is: 6, message: "should only be 6 digits"}, numericality: {only_number: true},
              presence:true

    validates :accountNumber, length: {minimum: 8, maximum: 9, message: "should be between 8-9 digits"},
                              uniqueness: true, numericality: {only_integer: true}, presence:true

    validates :currency, inclusion: { in: %w(GBP EUR USD), message: "%{value} is not a supported currency"}

    before_save :default_balance_and_currency


    private

        def default_balance_and_currency()
          #sets default values if not specified in creation of record
          if self.balance.nil?
            self.balance = 0
          end

          if self.currency.nil?
            self.currency = "GBP"
          end
        end

        # Function used to generate CSV file of accounts
        def self.export_csv(accounts_to_export)
            attributes = ['created_at', 'id', 'user_id', 'accountNumber', 'sortCode', 'balance', 'currency'] # Attributes from Accounts model
            headers = ['Date Created', 'Account ID', 'User ID', 'Account Number', 'Sort Code', 'Balance', 'Currency',] # Headers for the CSV file
            CSV.generate(headers: true) do |csv|
                csv << headers # Append the headers to the CSV files to serve as 'titles'
                accounts_to_export.each do |account|
                    # For each user, add the necessary attributes to the CSV file as a row
                    csv << account.attributes.values_at(*attributes)
              end
            end
        end
end
