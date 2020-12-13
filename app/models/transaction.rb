class Transaction < ApplicationRecord

    # Transaction validation
    validates :sender_id, presence: true,
                          numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "must be valid (number and greater than 0)"  }

    validates :receiver_id, presence: true,
                          numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "must be valid (number and greater than 0)"  }

    validates :amount, presence: true,
                            numericality: { only_number: true, greater_than: 0.0, message: "must be greater than 0" }

    validate :sender_and_receiver_unique

    # Model relationships:
    # Each transaction belongs to 2 accounts, a sender account and a receiver account. 
    # They belong to accounts 'optionally', because fake transactions do not always map to 2 valid/real accounts
    belongs_to :sender, :class_name => 'Account',  optional: :true
    belongs_to :receiver, :class_name => 'Account', optional: :true


    # Function used to generate CSV file of transactions
    def self.export_csv(transactions_to_export, user = nil)
        # There are 2 different ways to export to CSV, either the admin, or the user
        # If the user is not an admin, it must be clear whether the user is the sender or the receiver 
        # By default, we assume the user is an admin
        if(user.nil?)
            # If the user is an admin
            headers = ['Date Created', 'Sender', 'Receiver', 'Amount'] # Headers for the CSV file
        else
            # If the user is not an admin
            headers = ['Date', 'Sender', 'Receiver', 'Amount', 'Sent/Received'] # Headers for the CSV file
        end

        attributes = ['created_at', 'sender_id', 'receiver_id'] # Attributes from the Transaction model
        
        CSV.generate(headers: true) do |csv|
            csv << headers # Append the headers to the CSV files to serve as 'titles'
            transactions_to_export.each do |transaction|
                # For each transaction, add the necessary attributes to an array of strings then add it to the CSV as a row
                append = transaction.attributes.values_at(*attributes)
                if(user.nil?)
                    # If the user is an admin, we do not need to determine whether the amount was sent or received, as the admin is not involved in the transaction
                    append << transaction.amount
                else
                    # Determine if the user made or received the transaction
                    if(user.accounts.exists?(:id => transaction.sender_id)) 
                        direction = 'Sent'
                    else
                        direction = 'Received'
                    end
                    append << transaction.amount
                    append << direction
                end
               
               csv << append # Add the array to a new row in the CSV
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
