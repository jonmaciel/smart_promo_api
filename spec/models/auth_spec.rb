require 'rails_helper'

describe Auth, type: :model do
  describe 'basic validations' do
    it { is_expected.to validate_presence_of(:password).on(:create) }
    it { is_expected.to validate_length_of(:password).is_at_least(4).on(:create) }
    it { is_expected.to validate_presence_of(:password_confirmation).on(:create) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:source).optional }
  end

  describe 'validation' do
    describe '#email' do
      describe 'email format' do
        it 'validates email format' do
          expect { 
            Auth.create!(email: 'wrong mail', password: '1234', password_confirmation: '1234' )
          }.to raise_error(ActiveRecord::RecordInvalid)

          expect { 
            Auth.create!(email: 'mail@test.com', password: '1234', password_confirmation: '1234' )
          }.to_not raise_error
        end
      end

      describe 'email uniqueness' do
        it 'validates email' do
          expect { 
            Auth.create!(email: 'mail2@mail2.com', password: '1234', password_confirmation: '1234' )
            Auth.create!(email: 'mail2@mail2.com', password: '1234', password_confirmation: '1234' )
          }.to raise_error(ActiveRecord::RecordInvalid)

          expect { 
            Auth.create!(email: 'mail3@mail3.com', password: '1234', password_confirmation: '1234' )
            Auth.create!(email: 'mail4@mail4.com', password: '1234', password_confirmation: '1234' )
          }.to_not raise_error

          expect { 
            Auth.create!(email: nil, password: '1234', password_confirmation: '1234' )
            Auth.create!(email: nil, password: '1234', password_confirmation: '1234' )
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      describe 'email presence' do
        context 'when cellphone is empty' do
          it 'validates email' do
            expect { 
              Auth.create!(email: nil, password: '1234', password_confirmation: '1234' )
            }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end

        context 'when cellphone is not empty' do
          it 'does not validate email' do
            expect { 
              Auth.create!(email: nil, cellphone_number: '41992855073',  password: '1234', password_confirmation: '1234' )
            }.to_not raise_error
          end
        end
      end
    end

    describe '#cellphone_number' do
      describe 'cellphone_number format' do
        it 'validates email format' do
          expect { 
            Auth.create!(cellphone_number: 'wrong cellphone', password: '1234', password_confirmation: '1234' )
          }.to raise_error(ActiveRecord::RecordInvalid)

          expect { 
            Auth.create!(cellphone_number: '41992855073', password: '1234', password_confirmation: '1234' )
          }.to_not raise_error
        end
      end

      describe 'cellphone_number uniqueness' do
        it 'validates email' do
          expect { 
            Auth.create!(cellphone_number: '41992855070', password: '1234', password_confirmation: '1234' )
            Auth.create!(cellphone_number: '41992855070', password: '1234', password_confirmation: '1234' )
          }.to raise_error(ActiveRecord::RecordInvalid)

          expect { 
            Auth.create!(cellphone_number: '41992855073', password: '1234', password_confirmation: '1234' )
            Auth.create!(cellphone_number: '41992855074', password: '1234', password_confirmation: '1234' )
          }.to_not raise_error

          expect { 
            Auth.create!(cellphone_number: nil, password: '1234', password_confirmation: '1234' )
            Auth.create!(cellphone_number: nil, password: '1234', password_confirmation: '1234' )
          }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe 'methods' do
    describe '#find_by_login' do
      let!(:auth_with_email) { create(:auth, email: 'test1@test.com', password: '1234', password_confirmation: '1234') }
      let!(:auth_with_cellphone_number) { create(:auth, cellphone_number: '41992855073', password: '1234', password_confirmation: '1234') }

      context 'when login is email' do
        it 'returns auth by email' do
          auth = Auth.find_by_login('test1@test.com')
          expect(auth).to eql auth_with_email
        end
      end

      context 'when login is cellphone_number' do
        it 'returns auth by login' do
          auth = Auth.find_by_login('41992855073')
          expect(auth).to eql auth_with_cellphone_number
        end
      end
    end
  end
end
