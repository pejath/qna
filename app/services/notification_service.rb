# frozen_string_literal: true

class NotificationService
  def send_update_notice(answer)
    answer.question.subscriptions.each do |sub|
      NotificationMailer.question_update(sub.user, answer).deliver_later
    end
  end
end
