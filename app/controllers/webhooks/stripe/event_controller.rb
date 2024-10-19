module Webhooks
  module Stripe
    class EventController < ActionController::API
      # /webhooks/stripe/events
      def handle
        
        puts 'Hello ------'
        puts params.inspect
      end
    end
  end
end
