# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'attachable', Answer
  it_behaves_like 'commentable'
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  describe 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:question) }
  end
end
