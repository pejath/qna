# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe "POST #create" do
    subject(:http_request) { post :create, params: params }
    let(:question) { create(:question) }

    context "with valid attributes" do
      let(:params) { { question_id: question, answer: attributes_for(:answer, question: question) } }

      it "saves a new answer in the database" do
        expect { http_request }.to change(Answer, :count).by(1)
      end

      it "redirects to associated question" do
        expect(http_request).to redirect_to question
      end

      it 'saves a answer with correct association' do
        http_request
        expect(assigns(:new_answer).question_id).to eq question.id
      end
    end

    context "with invalid attributes" do
      let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid, question: question) } }

      it "doesn't save a new question in the database" do
        expect { http_request }.not_to change(Answer, :count)
      end

      it "re-render new" do
        expect(http_request).to render_template :new
      end
    end
  end

end
