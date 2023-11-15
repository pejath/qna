# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationService do
  let!(:users) { create_list(:user, 3) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question:) }

  before do
    users.each do |user|
      create(:subscription, user:, question:)
    end
  end

  it 'sends notification to all subscribed users' do
    expect(NotificationMailer).to receive(:question_update).exactly(4).and_call_original
    subject.send_update_notice(answer)
  end
end
