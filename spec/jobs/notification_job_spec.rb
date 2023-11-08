require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('NotificationService') }
  let(:answer) { create(:answer) }

  before do
    allow(NotificationService).to receive(:new).and_return(service)
  end

  it 'calls DailyDigestService#send_digest' do
    expect(service).to receive(:send_update_notice).with(answer)
    NotificationJob.perform_now(answer)
  end
end
