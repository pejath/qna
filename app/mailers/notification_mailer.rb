# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.question_update.subject
  #
  def question_update(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email, subject: 'New Answer'
  end
end
