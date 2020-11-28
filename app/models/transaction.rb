class Transaction < ApplicationRecord

    # Transaction validation
    validates :sender_id, presence: true,
                          numericality: { only_integer: true }

    validates :receiver_id, presence: true,
                          numericality: { only_integer: true }

    validates :amount, presence: true,
                            numericality: { only_integer: true, greater_than: 0 }

    validates :sender_and_receiver_unique

    belongs_to :sender, :foreign_key => :user_id,:class_name => 'Account', optional: :true
    belongs_to :receiver, :foreign_key => :user_id, :class_name => 'Account', optional: :true

    private
        def sender_and_receiver_unique
            self.sender_id != self.receiver_id
        end
end
