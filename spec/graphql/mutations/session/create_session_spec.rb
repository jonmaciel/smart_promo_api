# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoPublicApiSchema do
  let(:variables) { {} }
  let(:result) do
    res = described_class.execute(
      mutation_string,
      context: {},
      variables: variables
    )

    pp res if res['errors']
    res
  end

  describe 'Login' do
    let(:login) { 'joaomaciel.n@gmail.com' }
    let(:password) { '1234' }
    let(:variables) do
      {
        login: login,
        password: password,
      }
    end
    let(:mutation_string) do
      %|
        mutation login($login: String!, $password: String!) {
          createSession(login: $login, password: $password) {
            authToken
          }
        }
      |
    end

    let(:returned_token) do
      result['data']['createSession']['authToken']
    end

    let(:returned_error) do
      result['errors'][0]['message']
    end

    context 'when it is succefully authenticated' do
      it 'returns the righ challenge' do
        result = double(AuthenticateUser, result: { token:  'token' }, success?: true)

        expect(AuthenticateUser).to receive(:call).with(login, password).and_return(result)
        expect(returned_token).to eql 'token'
      end
    end

    context 'when it is not succefully authenticated' do
      it 'returns the righ challenge' do
        result = double(AuthenticateUser, success?: false)

        expect(AuthenticateUser).to receive(:call).with(login, password).and_return(result)
        expect(returned_error).to eql 'unauthorized'
      end
    end
  end
end
