class Account < ApplicationRecord
    belongs_to :user, :foreign_key => :user_id
    has_many :sent_transactions, :foreign_key => :sender_id, :class_name => 'Transaction'
    has_many :received_transactions, :foreign_key => :receiver_id, :class_name => 'Transaction'
end
