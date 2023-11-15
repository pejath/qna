# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'POST #create', js: true do
    subject(:http_request) { post :create, params:, format: :js }
    before { sign_in(user) }

    context 'with valid attributes' do
      let(:params) { { question_id: question } }

      it 'saves a new answer in the database' do
        expect { http_request }.to change(Subscription, :count).by(1)
      end

      it 'redirects to associated question' do
        expect(http_request).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy', js: true do
    subject(:http_request) { delete :destroy, params:, format: :js }
    before { sign_in(user) }
    let!(:sub) { create(:subscription, question:, user:) }

    context 'with valid attributes' do
      let(:params) { { question_id: question } }

      it 'saves a new answer in the database' do
        expect { http_request }.to change(Subscription, :count).by(-1)
      end

      it 'redirects to associated question' do
        expect(http_request).to render_template :destroy
      end
    end
  end
end
