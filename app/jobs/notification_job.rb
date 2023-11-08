# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    NotificationService.new.send_update_notice(answer)
  end
end
