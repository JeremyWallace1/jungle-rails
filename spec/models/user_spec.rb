require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

RSpec.describe User, type: :model do
  describe 'Validations' do
    # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    # validation tests/examples here
    context 'full validation' do
      it 'creates a user with all five fields set' do
        # create method saves as well
        user = User.create({
          first_name: 'Jeremy',
          last_name: 'Wallace',
          email: 'TEST@TEST.com',
          password: 'bananahammock',
          password_confirmation: 'bananahammock'
        })
        expect(user.id).not_to be_nil
        expect(user.first_name).to eq('Jeremy')
        expect(user.last_name).to eq('Wallace')
        expect(user.email.downcase).to eq('test@test.com')
        expect(user.password_digest).not_to be_nil
      end
    end

    context 'password validation' do
      it 'does not create user if password not entered' do
        user = User.create({
          first_name: 'Jeremy',
          last_name: 'Wallace',
          email: 'tEsT@tEsT.cOm',
          password: '',
          password_confirmation: ''
        })
        # pp user.errors.full_messages
        expect(user.errors.full_messages).to include("Password can't be blank")
        expect(user.id).to be_nil
      end
      it 'does not create user if passwords do not match' do
        # create method saves as well
        user = User.create({
          first_name: 'Jeremy',
          last_name: 'Wallace',
          email: 'TEST@TEST.com',
          password: 'bananahammock',
          password_confirmation: 'bananahammock!'
        })
        expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
        expect(user.id).to be_nil
      end
      it 'does not create user if password length < 8 characters' do
        user = User.create({
          first_name: 'Jeremy',
          last_name: 'Wallace',
          email: 'TEST@TEST.com',
          password: 'banana',
          password_confirmation: 'banana'
        })
        # pp user.errors.full_messages
        expect(user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
        expect(user.id).to be_nil
      end
    end

    context 'email validation' do
      it 'does not create user if email left blank' do
        user = User.create({
          first_name: 'Jeremy',
          last_name: 'Wallace',
          email: '',
          password: 'bananahammock',
          password_confirmation: 'bananahammock'
        })
        # pp user.errors.full_messages
        expect(user.errors.full_messages).to include("Email can't be blank")
        expect(user.id).to be_nil
      end
      it 'does not create user if email already exists' do
        # create method saves as well
        user = User.create({
          first_name: 'Jeremy',
          last_name: 'Wallace',
          email: 'TEST@TEST.com',
          password: 'bananahammock',
          password_confirmation: 'bananahammock'
        })
        user2 = User.create({
          first_name: 'Jeremy',
          last_name: 'Wallace',
          email: 'test@test.com',
          password: 'bananahammock',
          password_confirmation: 'bananahammock'
        })
        # pp user2.errors.full_messages
        # pp User.all
        expect(user2.errors.full_messages).to include("Email has already been taken")
        expect(user.id).not_to be_nil
        expect(user2.id).to be_nil
      end
    end

    context 'first_name validation' do
      it 'does not create user if first_name not entered' do
        # create method saves as well
        user = User.create({
          first_name: '',
          last_name: 'Wallace',
          email: 'TEST@TEST.com',
          password: 'bananahammock',
          password_confirmation: 'bananahammock'
        })
        # pp user.errors.full_messages
        expect(user.errors.full_messages).to include("First name can't be blank")
        expect(user.id).to be_nil
      end
    end

    context 'last_name validation' do
      it 'does not create user if last_name not entered' do
        # create method saves as well
        user = User.create({
          first_name: 'Jeremy',
          last_name: '',
          email: 'TEST@TEST.com',
          password: 'bananahammock',
          password_confirmation: 'bananahammock'
        })
        # pp user.errors.full_messages
        expect(user.errors.full_messages).to include("Last name can't be blank")
        expect(user.id).to be_nil
      end
    end
  end
end
