class Account < ApplicationRecord
    belongs_to :user, :foreign_key => :user_id
    has_many :sent_transactions, :foreign_key => :sender_id, :class_name => 'Transaction'
    has_many :received_transactions, :foreign_key => :receiver_id, :class_name => 'Transaction'

    validates :user_id, presence:true

    validates :sortCode, length: {is: 6}, numericality: {only_integer: true}

    validates :accountNumber, length: {minimum: 8, maximum: 9},
                              uniqueness: true, numericality: {only_integer: true}

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
end
