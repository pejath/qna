shared_examples_for 'POST #add_comment' do |desc_class|
  subject(:http_request) { post :add_comment, params: params, format: :json }

  let!(:resource) { create(desc_class) }

  context 'unauthenticated user' do
    let(:params) { { id: resource, body: 'new body' } }

    it 'can not add comment' do
      expect { http_request }.to_not change(Comment, :count)
    end
  end

  context 'authenticated user', js: true do
    before { login(user) }

    context 'with valid attributes' do
      let(:params) { { id: resource, body: 'new body' } }

      it 'can add comment with valid attributes' do
        expect { http_request }.to change(Comment, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { id: resource, body: nil } }

      it 'can not add comment with invalid attributes' do
        expect { http_request }.to_not change(Comment, :count)
      end
    end
  end
end
