# frozen_string_literal: true

class FilesController < ApplicationController
  def purge
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
  end
end
