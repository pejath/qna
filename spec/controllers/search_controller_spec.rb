# frozen_string_literal: true

require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    subject(:http_request) { get :index, params: {} }

    it 'returns success status' do
      expect(http_request).to have_http_status(:success)
    end

    it 'renders index template' do
      expect(http_request).to render_template :index
    end
  end
end
