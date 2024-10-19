class Subscription < ApplicationRecord
  state_machine :status, initial: :unpaid do
    event :pay do
      transition unpaid: :paid  
    end

    event :cancel do
      transition paid: :cancel
    end
  end
end
