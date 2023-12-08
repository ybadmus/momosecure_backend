# frozen_string_literal: true

shared_examples 'shared_responses' do
  shared_examples 'returns ok' do
    it 'returns ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  shared_examples 'returns 404' do
    it 'returns 404' do
      expect(code_response).to eq 404
    end
  end

  shared_examples 'returns 400' do
    it 'returns 400' do
      expect(code_response).to eq 400
    end
  end

  shared_examples 'returns 401' do
    it 'returns 401' do
      expect(code_response).to eq 401
    end
  end

  shared_examples 'returns 200' do
    it 'returns 200' do
      expect(code_response).to eq 200
    end
  end

  shared_examples 'returns 201' do
    it 'returns 201' do
      expect(code_response).to eq 201
    end
  end

  shared_examples 'returns success' do
    it 'returns success' do
      expect(error_response).to eq('success')
    end
  end
end
