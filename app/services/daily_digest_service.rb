# frozen_string_literal: true

class DailyDigestService
  def send_digest
    if any_last_questions?
      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.digest(user).deliver_later
      end
    end
  end

  def any_last_questions?
    Question.where(created_at: Time.now - 1.day..Time.now).any?
  end
end
