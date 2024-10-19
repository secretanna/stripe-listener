# frozen_string_literal: true

module Webhooks
  module Stripe
    class EventController < ActionController::API
      # /webhooks/stripe/events
      def handle
        payload = request.body.read
        sig_header = request.env['HTTP_STRIPE_SIGNATURE']
        event = nil

        begin
          event = ::Integrations::StripeService.webhook_event(payload, sig_header)
        rescue ::JSON::ParserError => e
          # Invalid payload
          puts "Error parsing payload: #{e.message}"
          head :unauthorized
          return
        rescue ::Stripe::SignatureVerificationError => e
          # Invalid signature
          puts "Error verifying webhook signature: #{e.message}"
          head :unauthorized
          return
        end

        case event.type
        when 'customer.subscription.created'
          subscription = event.data.object
          Subscription.create!(idx: subscription.id, original_payload: event.data.object.to_s)
        when 'customer.subscription.deleted'
          subscription = event.data.object
          Subscription.find_by!(idx: subscription.id).cancel!
        when 'invoice.payment_succeeded'
          Subscription.find_by!(idx: event.data.object.subscription).pay!
        else
          puts "Unhandled event type: #{event.type}"
        end
      end
    end
  end
end
