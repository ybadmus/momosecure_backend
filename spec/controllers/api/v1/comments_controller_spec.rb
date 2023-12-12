# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CommentsController do
  let(:admin) { create(:admin) }
  let(:admin_user_auth) { create(:user_auth, :admin, email: 'admin@momosecure.co') }
  let(:customer_user_auth) { create(:user_auth, :customer, email: 'customer@momosecure.co') }

  describe 'GET /index' do
    context 'with authorized user credentials' do
      before do
        prepare_authentication(user_auth)
        get 'index', params: { commentable_type: '', commentable_id: '' }
      end

      it 'return success' do
        expect(code_response).to eq 200
      end
    end
  end
end
