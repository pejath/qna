# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:nullify) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:rewards) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double 'FindForOauthService' }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
