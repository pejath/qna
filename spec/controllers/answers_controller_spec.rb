# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  it_behaves_like 'POST #vote', :answer
  it_behaves_like 'POST #add_comment', :answer

  describe 'POST #create' do
    subject(:http_request) { post :create, params: params, format: :js }
    before { sign_in(user) }

    context 'with valid attributes' do
      let(:params) { { answer: attributes_for(:answer, question: question), question_id: question.id } }

      it 'saves a new answer in the database' do
        expect { http_request }.to change(Answer, :count).by(1)
      end

      it 'redirects to associated question' do
        expect(http_request).to render_template :create
      end

      it 'saves a answer with correct association' do
        http_request
        expect(assigns(:answer).question_id).to eq question.id
      end
    end

    context 'with invalid attributes' do
      let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid, question: question) } }

      it "doesn't save a new question in the database" do
        expect { http_request }.not_to change(Answer, :count)
      end

      it 're-render question#show' do
        expect(http_request).to render_template :create
      end
    end
  end

  describe 'PATCH #upadte' do
    subject(:http_request) { patch :update, params: params, format: :js }
    let!(:answer) { create(:answer, question: question) }
    before { sign_in(user) }

    context 'with valid attributes' do
      let(:params) { { id: answer.id, answer: { body: 'new body' } } }

      it 'changes answer attributes' do
        http_request
        answer.reload
        expect(answer.body).to eq('new body')
      end

      it 'renders update view' do
        expect(http_request).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:params) { { id: answer.id, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer attrinutes' do
        expect { http_request }.to_not change(answer, :body)
      end

      it 'renders update view' do
        expect(http_request).to render_template :update
      end
    end
  end
end
