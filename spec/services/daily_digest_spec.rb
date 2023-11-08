require 'rails_helper'

RSpec.describe DailyDigestService do
  let!(:users) { create_list(:user, 3) }
  let!(:questions) { create_list(:question, 3, user: users[0]) }

  it 'sends daily digest to all users' do
    expect(DailyDigestMailer).to receive(:digest).exactly(3).and_call_original
    subject.send_digest
  end
end