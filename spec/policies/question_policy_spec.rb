# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionPolicy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions :edit? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:question))
    end

    it 'grant access if user is author' do
      expect(subject).to permit(user, create(:question, user:))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:question, user:))
    end
  end
end
