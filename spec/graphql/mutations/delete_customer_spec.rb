# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SmartPromoApiSchema do
  let(:context) { {} }
  let(:variables) { {} }
  let(:result) do
    res = described_class.execute(
      mutation_string,
      context: context,
      variables: variables
    )

    pp res if res['errors']
    res
  end

  describe 'Delete Customer' do
    let(:context) { { current_user: auth } }
    let!(:auth) { create(:auth, email: 'old@mail.com', password: '123456', password_confirmation: '123456', source: customer) }
    let(:customer) { create(:customer, name: 'Old Name', cpf: '07712973946') }
    let(:id) { customer.id }
    let(:variables) do
      { id: id }
    end
    let(:mutation_string) { 
      %| 
        mutation deleteCustomer($id: Int!){
          deleteCustomer(id: $id) {
            success
            errors
          }
        } 
      | 
    }

    context "when the customer has been found" do
      it 'returns the righ customer' do
        mutation_result = result['data']['deleteCustomer']['success']

        expect(Customer.find_by(id: id)).to be_nil
        expect(Auth.find_by(id: auth.id)).to be_nil
        expect(mutation_result).to be_truthy
      end

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(-1)
      end

      it 'creates new customer' do
        expect { result }.to change { Customer.count }.by(-1)
      end
    end

    context "when the user is invalid" do
      let(:other_costumer) { create(:customer, name: 'Other Name', cpf: '07712973947') }
      let(:other_auth) { create(:auth, cellphone_number: '41992855074', email: 'other@other.com', password: '1234', password_confirmation: '1234', source: customer) }
      let!(:id) { other_auth.id }

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(0)
      end

      it 'creates new customer' do
        expect { result }.to change { Customer.count }.by(0)
      end
    end

    context "when the customer has not been found" do
      let(:id) { -1 }

      it 'creates its auth' do
        expect { result }.to change { Auth.count }.by(0)
      end

      it 'creates new customer' do
        expect { result }.to change { Customer.count }.by(0)
      end
    end
  end
end
