require 'rails_helper'

RSpec.describe Webhooks::Stripe::EventController, type: :controller do
  let(:event_id) { 'evt_123' }
  let(:payload) { { id: event_id, type: event_type, data: { object: object_data } }.to_json }
  let(:sig_header) { 'signature_header' }

  before do
    StripeEvent = Struct.new(:id, :type, :data)
    StripeEventData = Struct.new(:object)
    StripeObjectData = Struct.new(:id, :subscription)
    
    allow(request).to receive(:body).and_return(StringIO.new(payload))
    allow(request).to receive(:env).and_return({ 'HTTP_STRIPE_SIGNATURE' => sig_header })
    allow(Integrations::StripeService).to receive(:webhook_event)
      .and_return(StripeEvent.new(event_id, event_type, StripeEventData.new(object_data)))
  end

  context 'when the event type is customer.subscription.created' do
    let(:event_type) { 'customer.subscription.created' }
    let(:object_data) { StripeObjectData.new(id: 'sub_123') }

    it 'creates a new subscription' do
      expect {
        post :handle
      }.to change(Subscription, :count).by(1)
      expect(Subscription.last.idx).to eq('sub_123')
    end
  end

  context 'when the event type is customer.subscription.deleted' do
    let(:event_type) { 'customer.subscription.deleted' }
    let(:object_data) { StripeObjectData.new(id: 'sub_123') }
    let!(:subscription) { Subscription.create!(idx: 'sub_123', status: :paid) }

    it 'cancels the subscription' do
      expect(subscription.status).to_not eq('canceled')
      post :handle
      expect(subscription.reload.status).to eq('canceled')
    end
  end

  context 'when the event type is invoice.payment_succeeded' do
    let(:event_type) { 'invoice.payment_succeeded' }
    let(:object_data) { StripeObjectData.new(subscription: 'sub_123') }
    let!(:subscription) { Subscription.create!(idx: 'sub_123', status: :unpaid) }

    it 'marks the subscription as paid' do
      expect(subscription.status).to_not eq('paid')
      post :handle
      expect(subscription.reload.status).to eq('paid')
    end
  end

  context 'when the event type is unsupported' do
    let(:event_type) { 'unsupported.event' }
    let(:object_data) { {} }

    it 'does not create or modify any subscriptions' do
      expect {
        post :handle
      }.to_not change(Subscription, :count)
    end
  end
end
