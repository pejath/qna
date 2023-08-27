require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
    # subject { FactoryBot.build(:question) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
