class Transaction < ApplicationRecord
    belongs_to :sender, :foreign_key => :user_id,:class_name => 'Account', optional: :true
    belongs_to :receiver, :foreign_key => :user_id, :class_name => 'Account', optional: :true

end
