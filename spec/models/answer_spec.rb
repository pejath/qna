# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to have_many(:links) }
    it { is_expected.to accept_nested_attributes_for(:links) }
  end
end
