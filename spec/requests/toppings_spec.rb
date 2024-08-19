require 'rails_helper'

RSpec.describe 'Toppings', type: :request do
  def create_new_topping(attribs)
    Topping.create(attribs)
  end

  let(:valid_attribs) { { name: 'A new topping' } }
  let(:invalid_attribs) { valid_attribs.merge(name: '') }

  describe 'GET /index' do
    it 'returns list of available toppings' do
      new_topping = create_new_topping(valid_attribs)
      get toppings_url

      expect(response).to be_successful
      expect(response.body).to include(new_topping.name)
    end
  end

  describe 'GET /new' do
    it 'instantiates new Topping' do
      get new_topping_url

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Topping' do
        expect {
          post toppings_url, params: { topping: valid_attribs }
        }.to change(Topping, :count).by(1)
      end

      it 'redirects to the newly created Topping' do
        post toppings_url, params: { topping: valid_attribs }

        expect(response).to redirect_to(topping_url(Topping.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Topping' do
        expect {
          post toppings_url, params: { topping: invalid_attribs }
        }.to change(Topping, :count).by(0)
      end

      it 'returns errors' do
        post toppings_url, params: { topping: invalid_attribs }

        expect(response).to be_unprocessable
      end
    end
  end

  describe 'GET /show' do
    it 'returns existing Topping attributes' do
      new_topping = create_new_topping(valid_attribs)
      get edit_topping_url(new_topping)

      expect(response).to be_successful
      expect(response.body).to include(new_topping.name)
    end
  end

  describe "GET /edit" do
    it 'returns existing Topping attributes' do
      new_topping = create_new_topping(valid_attribs)
      get edit_topping_url(new_topping)

      expect(response).to be_successful
      expect(response.body).to include(new_topping.name)
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:update_attribs) { {name: 'Updated topping' } }

      it 'updates existing Topping' do
        new_topping = create_new_topping(valid_attribs)
        patch topping_url(new_topping), params: { topping: update_attribs }

        expect(Topping.find(new_topping.id).name).to eql(update_attribs[:name])
      end

      it 'redirects to the existing Topping' do
        new_topping = create_new_topping(valid_attribs)
        patch topping_url(new_topping), params: { topping: update_attribs }

        expect(response).to redirect_to(topping_url(new_topping))
      end
    end

    context 'with invalid parameters' do
      it 'does not update existing Topping' do
        new_topping = create_new_topping(valid_attribs)
        expect {
          patch topping_url(new_topping), params: { topping: invalid_attribs }
        }.not_to change(new_topping, :name).from(new_topping.name)
      end

      it 'returns errors' do
        new_topping = create_new_topping(valid_attribs)
        patch topping_url(new_topping), params: { topping: invalid_attribs }

        expect(response).to be_unprocessable
      end
    end
  end

  describe "DELETE /destroy" do
    it 'removes the requested Topping' do
      new_topping = create_new_topping(valid_attribs)
      expect {
        delete topping_url(new_topping)
      }.to change(Topping, :count).by(-1)
      expect {new_topping.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'redirects to the list of available toppings' do
      new_topping = create_new_topping(valid_attribs)
      delete topping_url(new_topping)

      expect(response).to redirect_to(toppings_url)
      expect(response.body).not_to include(new_topping.name)
    end
  end
end
