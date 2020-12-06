class Transaction < ApplicationRecord

    # Transaction validation
    validates :sender_id, presence: true,
                          numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "must be valid (number and greater than 0)"  }

    validates :receiver_id, presence: true,
                          numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "must be valid (number and greater than 0)"  }

    validates :amount, presence: true,
                            numericality: { only_number: true, greater_than: 0, message: "must be greater than 0" }

    validate :sender_and_receiver_unique

    belongs_to :sender, :class_name => 'Account',  optional: :true
    belongs_to :receiver, :class_name => 'Account', optional: :true


    # Function used to generate CSV file of transactions
    def self.export_csv(transactions_to_export, current_user = nil)
        if(current_user.nil?)
            headers = ['Date Created', 'Sender', 'Receiver', 'Amount'] # Headers for the CSV file
        else
            headers = ['Date', 'Sender', 'Receiver', 'Amount', 'Sent/Received'] # Headers for the CSV file
        end
        attributes = ['created_at', 'sender_id', 'receiver_id'] # Attributes from the Transaction model
        
        CSV.generate(headers: true) do |csv|
            csv << headers # Append the headers to the CSV files to serve as 'titles'
            transactions_to_export.each do |transaction|
                # For each transaction, add the necessary attributes to an array of strings then add it to the CSV as a row
                append = transaction.attributes.values_at(*attributes)
                if(current_user.nil?)
                    append << transaction.amount
                else
                    if(current_user.accounts.exists?(:id => transaction.sender_id)) # Check if the user made or received the transaction
                        direction = 'Sent'
                    else
                        direction = 'Received'
                    end
                    append << transaction.amount
                    append << direction
                end
               
               csv << append # Add to the array to the CSV file
          end
        end
    end


    private
        def sender_and_receiver_unique
            if(sender_id == receiver_id)
                errors.add(:sender_id, "must be different from receiver")
                errors.add(:receiver_id, "must be different from sender")
            end
        end
end
