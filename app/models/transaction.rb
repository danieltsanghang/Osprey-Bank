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

    private
        def sender_and_receiver_unique
            if(sender_id == receiver_id)
                errors.add(:sender_id, "sender_id can't have the same id ad the receiver_id")
                errors.add(:receiver_id, "receiver_id can't have the same id ad the sender_id")
            end
        end
end
