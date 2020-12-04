class Transaction < ApplicationRecord

    # Transaction validation
    validates :sender_id, presence: true,
                          numericality: { only_integer: true }

    validates :receiver_id, presence: true,
                          numericality: { only_integer: true }

    validates :amount, presence: true,
                            numericality: { only_integer: true, greater_than: 0, message: "Amount must be greater than 0!" }

    validate :sender_and_receiver_unique

    belongs_to :sender, :foreign_key => :user_id,:class_name => 'Account', optional: :true
    belongs_to :receiver, :foreign_key => :user_id, :class_name => 'Account', optional: :true


    # Function used to generate CSV file of transactions
    def self.export_csv(transactions, current_user)
        attributes = ['created_at', 'sender_id', 'receiver_id', 'amount'] # Attributes from the Transaction model
        headers = ['Date', 'Sender', 'Receiver', 'Amount', 'Sent/Received'] # Headers for the CSV file
        CSV.generate(headers: true) do |csv|
            csv << headers # Append the headers to the CSV files to serve as 'titles'
            transactions.each do |transaction|
                # For each transaction, add the necessary attributes to an array of strings then add it to the CSV as a row
                append = transaction.attributes.values_at(*attributes)
               if(current_user.accounts.exists?(:id => transaction.sender_id)) # Check if the user made or received the transaction
                append << 'Sent'
               else
                append << 'Received'
               end
               csv << append # Add to the array to the CSV file
          end
        end
    end


    private
        def sender_and_receiver_unique
            if(sender_id == receiver_id)
                errors.add(:sender_id, "sender_id can't have the same id ad the receiver_id")
                errors.add(:receiver_id, "receiver_id can't have the same id ad the sender_id")
            end
        end
end
