# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:session) { { oauth: { 'provider' => 'vkontakte', 'uid' => '123' } } }
  subject(:http_request) { post :set_email, params:, session: }

  describe 'POST #set_email' do
    context 'without oauth params' do
      it 'redirect to root path' do
        post :set_email
        expect(response).to redirect_to root_path
      end
    end

    context 'with oauth params' do
      context 'with correct params' do
        let(:params) { { user: { email: 'test@test.com' } } }

        it 'redirect with correct params' do
          expect(http_request).to redirect_to root_path
        end

        it 'create authorization' do
          expect { http_request }.to change(Authorization, :count).by(1)
        end
      end

      context 'with incorrect params' do
        let(:params) { { user: { email: '121212' } } }

        it 'redirect with incorrect email' do
          expect(http_request).to render_template :set_email
        end

        it 'fail create authorization' do
          expect { http_request }.to_not change(Authorization, :count)
        end
      end
    end

    context 'email existed' do
      let!(:user) { create(:user, email: 'test@test.com') }
      let(:params) { { user: { email: 'test@test.com' } } }

      it 'render template' do
        expect(http_request).to render_template :set_email
      end

      it 'fail create authorization' do
        expect { http_request }.to_not change(Authorization, :count)
      end
    end
  end
end
