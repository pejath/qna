# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@qna.com'
  layout 'mailer'
end
