# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoPublicApiSchema do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) do
    res = described_class.execute(
      query_string,
      context: context,
      variables: variables
    )

    pp res if res['errors']
    res
  end

  describe 'customer_check' do
    let(:query_string) do
      %|
        query customerCheck($field: PublicCustomerCheckFieldsEnum!, $value: String!) {
          customerCheck(field: $field, value: $value)
        }
      | 
    end

    before do
      create(:customer, name: 'Name 1', cpf: '81106348001', auth_attributes: {
            cellphone_number: '41991234577',
            email: 'test1@test1.com',
            password: '123456',
            password_confirmation: '123456'
          }
      )
    end

    context 'check by cpf' do
      let(:variables) { { field: 'CPF',  value: '81106348001' } }

      it 'returns true' do
        expect(result['data']['customerCheck']).to be_truthy
      end
    end

    context 'check by cellphone_number' do
      let(:variables) { { field: 'CELLPHONE_NUMBER',  value: '41991234577' } }

      it 'returns true' do
        expect(result['data']['customerCheck']).to be_truthy
      end
    end

    context 'check by email' do
      let(:variables) { { field: 'EMAIL',  value: 'test1@test1.com' } }

      it 'returns true' do
        expect(result['data']['customerCheck']).to be_truthy
      end
    end

    context 'check by invalid' do
      let(:variables) { { field: 'CELLPHONE_NUMBER',  value: '41991234580' } }

      it 'returns false' do
        expect(result['data']['customerCheck']).to be_falsey
      end
    end
  end
end
