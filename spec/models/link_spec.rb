# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value('https://www.google.com/').for(:url) }
end
