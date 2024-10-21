# frozen_string_literal: true

module Integrations
  class StripeEventHandler
    SUPPORTED_EVENTS = ['customer.subscription.created', 'customer.subscription.deleted', 'invoice.payment_succeeded'].freeze

    def initialize(event)
      @event = event
    end

    def call
      Rails.logger.info 'The event is not supported' && return if SUPPORTED_EVENTS.exclude? @event.type

      send(@event.type.split('.').join('_'))
    end

    private

    def customer_subscription_created
      subscription = @event.data.object
      Subscription.create!(idx: subscription.id, original_payload: @event.data.object.to_s)
      Rails.logger.info 'Subscription was created'
    end

    def customer_subscription_deleted
      subscription = @event.data.object
      Subscription.find_by!(idx: subscription.id).cancel!
      Rails.logger.info 'Subscription was cancelled'
    end

    def invoice_payment_succeeded
      Subscription.find_by!(idx: @event.data.object.subscription).pay!
      Rails.logger.info 'Subscription was paid'
    end
  end
end
