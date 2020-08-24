require 'rails_helper'

RSpec.describe 'Results API', type: :request do

  # Test suite for GET /results
  describe 'GET /results' do
    context 'when the user provides a valid API token' do
      it 'allows the user to authenticate' do
        credentials = authenticate_with_token(ENV['API_TOKEN'])

        get '/results', headers: { 'Authorization' => credentials }

        expect(response).to be_successful
      end
    end

    context 'when the user provides an invalid API token' do
      it 'does not allow to user to authenticate' do

        credentials = authenticate_with_token('less-sekret')

        get '/results', headers: { 'Authorization' => credentials }

        expect(response).to be_unauthorized
      end
    end

  end

  private 

  def authenticate_with_token(token)
    ActionController::HttpAuthentication::Token.encode_credentials(token)
  end
end
