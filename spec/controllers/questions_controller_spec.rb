# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'renders the index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders the show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders the new template' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'renders the edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save a new question in the database" do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.not_to change(Question, :count)
      end

      it 're-render new' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #vote' do
    subject(:http_request) { post :vote, params: params, format: :json }
    let(:author) { create(:user) }
    let(:vote_question) { create(:question, user: author) }

    describe 'upvote action' do
      let(:params) { { id: vote_question.id, vote_action: 'upvote' } }

      context 'unauthenticated user' do
        it 'can not upvote the question' do
          expect { http_request }.to_not change(Vote, :count)
        end
      end

      context 'authenticated user' do
        before { login(user) }

        it 'upvote the question' do
          expect { http_request }.to change(Vote, :count).by(1)
        end
      end

      context 'author of the question' do
        before { login(author) }

        it 'can not upvote the question' do
          expect { http_request }.to_not change(Vote, :count)
        end
      end
    end

    describe 'downvote action' do
      let(:params) { { id: vote_question.id, vote_action: 'downvote' } }

      context 'unauthenticated user' do
        it 'can not downvote the question' do
          expect { http_request }.to_not change(Vote, :count)
        end
      end

      context 'authenticated user' do
        before { login(user) }

        it 'downvote the question' do
          expect { http_request }.to change(Vote, :count).by(1)
        end
      end

      context 'author of the question' do
        before { login(author) }

        it 'can not downvote the question' do
          expect { http_request }.to_not change(Vote, :count)
        end
      end
    end

    describe 'unvote action' do
      let(:params) { { id: vote_question.id, vote_action: 'unvote' } }
      let!(:vote) { create(:vote, user: user, votable: vote_question) }

      context 'unauthenticated user' do
        it 'can not unvote the question' do
          expect { http_request }.to_not change(Vote, :count)
        end
      end

      context 'authenticated user' do
        before { login(user) }

        it 'unvote the question' do
          expect { http_request }.to change(Vote, :count).by(-1)
        end
      end

      context 'author of the question' do
        before { login(author) }

        it 'can not unvote the question' do
          expect { http_request }.to_not change(Vote, :count)
        end
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    before { patch :update, params: { id: question, question: params }, format: :js }

    context 'with valid attributes' do
      let(:params) { { title: 'New Title', body: 'New Body' } }

      it 'changes question attributes' do
        question.reload

        expect(question.title).to eq 'New Title'
        expect(question.body).to eq 'New Body'
      end

      it 'redirects to updated question' do
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:params) { attributes_for(:question, :invalid) }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'Title'
        expect(question.body).to eq 'body'
      end

      it 'uses update js' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user: user) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }

      expect(response).to redirect_to questions_url
    end
  end
end
