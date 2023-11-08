# frozen_string_literal: true

shared_examples_for 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }
end
