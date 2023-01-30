require 'rails_helper'
require 'database_cleaner/active_record'

DatabaseCleaner.strategy = :truncation

RSpec.describe Product, type: :model do
  describe 'Validations' do
    # then, whenever you need to clean the DB
    DatabaseCleaner.clean
    # validation tests/examples here
    context 'full validation' do
      it 'creates a product with all four fields set' do
        # create method saves as well
        category = Category.create name: 'Trees'
        # puts category.inspect
        product = category.products.create({
          name:  'Banana Tree',
          quantity: 10,
          price: 39.99
        })
        expect(product.id).not_to be_nil
        expect(product.name).to eq('Banana Tree')
        expect(product.quantity).to be(10)
        expect(product.category.name).to eq('Trees')
        expect(product.price.fractional).to be(3999)
        expect(product.price.currency).to eq('cad')
        expect(Product.where(id: product.id)).to exist
        expect(Product.where(id: product.id)[0].name).to eq('Banana Tree')
      end
    end

    # validates :name, presence: true
    context 'validate error when no name entered' do
      it 'fails to create a product when name is nil' do
        category = Category.create name: 'Shrubs'
        # puts category.inspect
        product = category.products.create({
          quantity: 100,
          price: 19.99
        })
        # puts product.inspect
        expect(product.errors.full_messages).to include("Name can't be blank")
      end
    end

    # validates :price, presence: true
    context 'validate error when no price entered' do
      it 'fails to create a product when price is nil' do
        category = Category.create name: 'Shrubs'
        product = category.products.create({
          name: 'Raspberry bush',
          quantity: 100,
        })
        expect(product.errors.full_messages).to include("Price is not a number")
      end
    end

    # validates :quantity, presence: true
    context 'validate error when no quantity entered' do
      it 'fails to create a product when quantity is nil' do
        category = Category.create name: 'Shrubs'
        product = category.products.create({
          name: 'Raspberry bush',
          price: 12.95
        })
        expect(product.errors.full_messages).to include("Quantity can't be blank")
      end
    end

    # validates :category, presence: true
    context 'validate error when no category entered' do
      it 'fails to create a product when category is nil' do
        product = Product.create({
          name:  'Banana Tree',
          quantity: 10,
          price: 39.99
        })
        expect(product.errors.full_messages).to include("Category must exist")
        expect(product.errors.full_messages).to include("Category can't be blank")
      end
    end

  end
end
