class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url,  format: { with: URI::regexp }

  def is_gist?
    url.match?(/gist\.github/)
  end

  def gist_id
    url.split("/").last
  end
end
