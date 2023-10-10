# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { is_expected.to belong_to :question }
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :title }

  it 'have one attached image' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
