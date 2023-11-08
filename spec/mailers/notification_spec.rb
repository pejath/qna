# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'question_update' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer) }
    let(:mail) { NotificationMailer.question_update(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New Answer')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
