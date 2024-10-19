require 'stripe'

module Services
  module Integrations
    class StripeService
      API_KEY = Stripe.api_key = Rails.application.credentials.stripe.api_key
    end
  end
end
