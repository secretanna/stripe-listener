# frozen_string_literal: true

require 'stripe'

module Integrations
  class StripeService
    Stripe.api_key = Rails.application.credentials.stripe.api_key
    SECRET = Rails.application.credentials.stripe.endpoint_secret

    def self.webhook_event(payload, sig_header)
      Stripe::Webhook.construct_event(payload, sig_header, SECRET)
    end
  end
end
