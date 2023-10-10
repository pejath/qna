# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url,  format: { with: URI::DEFAULT_PARSER.make_regexp }

  def is_gist?
    url.match?(/gist\.github/)
  end

  def gist_id
    url.split('/').last
  end
end
