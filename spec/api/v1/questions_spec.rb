# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question:) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: }

      it 'returns that response successful' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'returns short title' do
        expect(question_response['short_title']).to eq question.title.truncate(4)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions/1' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question, :with_file, :with_link, :with_comments) }
      let(:response_question) { json['question'] }
      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: }

      it 'returns that response successful' do
        expect(response).to be_successful
      end

      it 'returns that response successful' do
        expect(json.size).to eq 1
      end

      it 'returns all public fields' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(response_question[attr]).to eq question.send(attr).as_json
        end
      end

      context 'file urls' do
        let(:files_response) { response_question['urls'].first }
        let(:file) { question.files.first }

        it 'returns files urls' do
          expect(files_response['url']).to eq rails_blob_url(file, only_path: true).as_json
        end

        it 'returns list of files' do
          expect(response_question['urls'].size).to eq 1
        end
      end

      context 'comments' do
        let(:comments_response) { response_question['comments'].first }
        let(:comment) { question.comments.first }

        it 'returns comments' do
          expect(comments_response).to eq comment.as_json
        end

        it 'returns list of comments' do
          expect(response_question['comments'].size).to eq 2
        end
      end

      context 'links' do
        let(:links_response) { response_question['links'].first }
        let(:link) { question.links.first }

        it 'returns links' do
          expect(links_response).to eq link.as_json
        end

        it 'returns list of links' do
          expect(response_question['links'].size).to eq 1
        end
      end
    end
  end

  describe 'POST /api/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { '/api/v1/questions/' }
    end

    describe 'authorized' do
      let(:me) { create(:user) }
      let!(:question) { attributes_for(:question) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        post '/api/v1/questions', params: { access_token: access_token.token, question: }, headers:
      end

      it 'returns that response successful' do
        expect(response).to be_successful
      end

      it 'changes Questions count' do
        expect(Question.count).to eq 1
      end

      context 'with invalid attributes' do
        let!(:question) { attributes_for(:question, :invalid) }

        it 'returns 422 code' do
          expect(response.status).to eq 422
        end

        it 'do not create question' do
          expect(Question.count).to eq 0
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let!(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    describe 'authorized' do
      let(:me) { create(:user) }
      let!(:question) { create(:question, user: me) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:http_request) { patch "/api/v1/questions/#{question.id}", params:, headers: }

      let(:params) { { access_token: access_token.token, question: { body: 'new body' } } }

      it 'returns that response successful' do
        http_request
        expect(response).to be_successful
      end

      it 'changes Questions count' do
        http_request
        question.reload
        expect(question.body).to eq('new body')
      end

      context 'with invalid attributes' do
        let(:params) { { access_token: access_token.token, question: { body: nil } } }

        it 'returns 422 code' do
          http_request
          expect(response.status).to eq 422
        end

        it 'do not update question' do
          http_request
          question.reload
          expect(question.body).to eq('body')
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let!(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    describe 'authorized' do
      let(:me) { create(:user) }
      let!(:question) { create(:question, user: me) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      let(:http_request) do
        delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers:
      end

      it 'returns that response successful' do
        http_request
        expect(response).to be_successful
      end

      it 'changes Questions count' do
        expect { http_request }.to change(Question, :count).by(-1)
      end
    end
  end
end
