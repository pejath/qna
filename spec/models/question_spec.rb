# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'attachable', Question
  it_behaves_like 'commentable'
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_one(:reward) }
    it { is_expected.to accept_nested_attributes_for(:reward) }
  end
end
