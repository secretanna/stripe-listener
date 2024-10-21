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
          Rails.logger.info "Error parsing payload: #{e.message}"
          head :unauthorized
          return
        rescue ::Stripe::SignatureVerificationError => e
          Rails.logger.info "Error verifying webhook signature: #{e.message}"
          head :unauthorized
          return
        end

        ::Integrations::StripeEventHandler.new(event).call
      end
    end
  end
end
