# frozen_string_literal: true

shared_examples_for 'POST #vote' do |desc_class|
  subject(:http_request) { post :vote, params:, format: :json }
  let(:author) { create(:user) }
  let(:resource) { create(desc_class, user: author) }

  describe 'upvote action' do
    let(:params) { { id: resource.id, vote_action: 'upvote' } }

    context 'unauthenticated user' do
      it "can not upvote the #{desc_class}" do
        expect { http_request }.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      before { login(user) }

      it "upvote the #{desc_class}" do
        expect { http_request }.to change(Vote, :count).by(1)
      end
    end

    context "author of the #{desc_class}" do
      before { login(author) }

      it "can not upvote the #{desc_class}" do
        expect { http_request }.to_not change(Vote, :count)
      end
    end
  end

  describe 'downvote action' do
    let(:params) { { id: resource.id, vote_action: 'downvote' } }

    context 'unauthenticated user' do
      it "can not downvote the #{desc_class}" do
        expect { http_request }.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      before { login(user) }

      it "downvote the #{desc_class}" do
        expect { http_request }.to change(Vote, :count).by(1)
      end
    end

    context "author of the #{desc_class}" do
      before { login(author) }

      it "can not downvote the #{desc_class}" do
        expect { http_request }.to_not change(Vote, :count)
      end
    end
  end

  describe 'unvote action' do
    let(:params) { { id: resource.id, vote_action: 'unvote' } }
    let!(:vote) { create(:vote, user:, votable: resource) }

    context 'unauthenticated user' do
      it "can not unvote the #{desc_class}" do
        expect { http_request }.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      before { login(user) }

      it "unvote the #{desc_class}" do
        expect { http_request }.to change(Vote, :count).by(-1)
      end
    end

    context "author of the #{desc_class}" do
      before { login(author) }

      it "can not unvote the #{desc_class}" do
        expect { http_request }.to_not change(Vote, :count)
      end
    end
  end
end
