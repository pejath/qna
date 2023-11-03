# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it 'returns that response successful' do
        expect(response).to be_successful
      end

      it 'returns all fields' do
        %w[id body created_at updated_at user_id].each do |attr|
          expect(json['answers'][0][attr]).to eq answers[0].send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/answers/1' }
    end

    context 'authorized' do
      let!(:answer) { create(:answer, :with_file, :with_link, :with_comments) }
      let(:access_token) { create(:access_token) }
      let(:response_answer) { json["answer"] }

      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns that response successful' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at user_id].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      context 'file urls' do
        let(:files_response) { response_answer['urls'].first }
        let(:file) { answer.files.first }

        it 'returns files urls' do
          expect(files_response['url']).to eq rails_blob_url(file, only_path: true).as_json
        end

        it 'returns list of files' do
          expect(response_answer['urls'].size).to eq 1
        end
      end

      context 'comments' do
        let(:comments_response) { response_answer['comments'].first }
        let(:comment) { answer.comments.first }

        it 'returns comments' do
          expect(comments_response).to eq comment.as_json
        end

        it 'returns list of comments' do
          expect(response_answer['comments'].size).to eq 2
        end
      end

      context 'links' do
        let(:links_response) { response_answer['links'].first }
        let(:link) { answer.links.first }

        it 'returns links' do
          expect(links_response).to eq link.as_json
        end

        it 'returns list of links' do
          expect(response_answer['links'].size).to eq 1
        end
      end
    end
  end

  describe 'POST /api/questions/:id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    describe 'authorized' do
      let(:me) { create(:user) }
      let(:question) { create(:question) }
      let!(:answer) { attributes_for(:answer) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { post "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, answer: answer }, headers: headers }

      it 'returns that response successful' do
        expect(response).to be_successful
      end

      it 'changes Answers count' do
        expect(Answer.count).to eq 1
      end

      context 'with invalid attributes' do
        let!(:answer) { attributes_for(:answer, :invalid) }

        it 'returns 422 code' do
          expect(response.status).to eq 422
        end

        it 'do not create answer' do
          expect(Answer.count).to eq 0
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let!(:answer) { create(:answer) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    describe 'authorized' do
      let(:me) { create(:user) }
      let!(:answer) { create(:answer, user: me) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:http_request) { patch "/api/v1/answers/#{answer.id}", params: params, headers: headers }

      let(:params) { { access_token: access_token.token, answer: { body: 'new body' } } }

      it 'returns that response successful' do
        http_request
        expect(response).to be_successful
      end

      it 'changes Answers count' do
        http_request
        answer.reload
        expect(answer.body).to eq('new body')
      end

      context 'with invalid attributes' do
        let(:params) { { access_token: access_token.token, answer: { body: nil } } }

        it 'returns 422 code' do
          http_request
          expect(response.status).to eq 422
        end

        it 'do not update answer' do
          http_request
          answer.reload
          expect(answer.body).to eq('MyText')
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let!(:answer) { create(:answer) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    describe 'authorized' do
      let(:me) { create(:user) }
      let!(:answer) { create(:answer, user: me) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      let(:http_request) { delete "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns that response successful' do
        http_request
        expect(response).to be_successful
      end

      it 'changes Answers count' do
        expect { http_request }.to change(Answer, :count).by(-1)
      end
    end
  end
end
