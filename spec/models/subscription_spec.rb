require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'state transitions' do
    let(:subscription) { Subscription.create }

    context 'when the subscription is unpaid' do
      it 'initializes with unpaid status' do
        expect(subscription.status).to eq('unpaid')
      end

      it 'transitions to paid when pay event is called' do
        subscription.pay
        expect(subscription.status).to eq('paid')
      end
    end

    context 'when the subscription is paid' do
      before { subscription.pay }

      it 'transitions to cancelled when cancel event is called' do
        subscription.cancel
        expect(subscription.status).to eq('cancel')
      end

      it 'does not transition to unpaid' do
        expect { subscription.pay }.to_not change(subscription, :status)
      end
    end
  end
end
