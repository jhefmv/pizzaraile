require 'rails_helper'

RSpec.describe 'Pizzas', type: :request do
  let(:valid_attribs) {
    {
      name: 'A new pizza',
      toppings_attributes: [{name: 'olives'}]
    }
  }
  let(:invalid_attribs) { valid_attribs.dup.merge(name: '') }
  let(:new_pizza) { Pizza.create(valid_attribs) }

  describe 'GET /index' do
    it 'returns list of available pizzas' do
      new_pizza
      get pizzas_url

      expect(response).to be_successful
      expect(response.body).to include(new_pizza.name)
    end

    it 'list toppings on each pizza' do
      new_pizza
      get pizzas_url

      expect(response).to be_successful
      expect(response.body).to include(new_pizza.topping_names)
    end
  end

  describe 'GET /new' do
    it 'instantiates new Pizza' do
      get new_pizza_url

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Pizza' do
        expect {
          post pizzas_url, params: { pizza: valid_attribs }
        }.to change(Pizza, :count).by(1)
      end

      it 'adds new toppings to created Pizza' do
        toppings = [{name: 'pineapple'}, {name: 'bacon'}]
        payload = valid_attribs.dup.merge(toppings_attributes: toppings)
        post pizzas_url, params: { pizza: payload }

        follow_redirect!
        expect(response.body).to include(toppings.map { |t| t[:name] }.join(', '))
      end

      it 'adds existing toppings to created Pizza' do
        toppings = [Topping.create(name: 'ham')]
        payload = {
          name: 'Ham & Cheese',
          topping_ids: toppings.map { |t| t.id },
          toppings_attributes: toppings.map { |t| {id: t.id} }.concat([id: nil, name: 'cheese']),
        }
        post pizzas_url, params: { pizza: payload }

        follow_redirect!
        expect(response.body).to include(toppings.map { |t| t.name }.join(', '))
      end

      it 'redirects to the newly created Pizza' do
        post pizzas_url, params: { pizza: valid_attribs }

        expect(response).to redirect_to(pizza_url(Pizza.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Pizza' do
        expect {
          post pizzas_url, params: { pizza: invalid_attribs }
        }.to change(Pizza, :count).by(0)
      end

      it 'does not allow duplicate Pizza' do
        new_pizza

        expect {
          post pizzas_url, params: { pizza: valid_attribs }
        }.to change(Pizza, :count).by(0)
        expect(response).to be_unprocessable
      end

      it 'does not allow duplicate topppings on a Pizza' do
        new_pizza
        toppings = [{name: new_pizza.toppings.first.name}, {name: 'bacon'}]
        payload = valid_attribs.dup.merge(name: 'Meaty', toppings_attributes: toppings)

        expect {
          post pizzas_url, params: { pizza: payload }
        }.to change(Pizza, :count).by(0)
        expect(response).to be_unprocessable
      end

      it 'returns errors' do
        post pizzas_url, params: { pizza: invalid_attribs }

        expect(response).to be_unprocessable
      end
    end
  end

  describe 'GET /show' do
    it 'returns existing Pizza attributes' do
      get edit_pizza_url(new_pizza)

      expect(response).to be_successful
      expect(response.body).to include(new_pizza.name)
    end

    it 'lists toppings on a Pizza' do
      get edit_pizza_url(new_pizza)

      expect(response).to be_successful
      expect(response.body).to include(new_pizza.topping_names)
    end
  end

  describe "GET /edit" do
    it 'returns existing Pizza attributes' do
      get edit_pizza_url(new_pizza)

      expect(response).to be_successful
      expect(response.body).to include(new_pizza.name)
    end

    it 'lists toppings on a Pizza' do
      get edit_pizza_url(new_pizza)

      expect(response).to be_successful
      expect(response.body).to include(new_pizza.topping_names)
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:update_attribs) { {name: 'Updated pizza' } }

      it 'updates existing Pizza' do
        patch pizza_url(new_pizza), params: { pizza: update_attribs }

        expect(Pizza.find(new_pizza.id).name).to eql(update_attribs[:name])
      end

      it 'adds new toppings to existing Pizza' do
        old_toppings = new_pizza.toppings.map(&:name)
        new_toppings = [{name: 'pineapple'}, {name: 'bacon'}]
        payload = update_attribs.dup.merge(toppings_attributes: new_toppings)
        patch pizza_url(new_pizza), params: { pizza: payload }

        follow_redirect!
        updated_toppings = old_toppings.concat(new_toppings.map { |t| t[:name] })
        expect(response.body).to include(updated_toppings.join(', '))
      end

      it 'adds existing toppings to created Pizza' do
        toppings = [Topping.create(name: 'ham')]
        payload = {
          name: 'Ham & Cheese',
          topping_ids: toppings.map { |t| t.id },
          toppings_attributes: toppings.map { |t| {id: t.id} }.concat([id: nil, name: 'cheese']),
        }
        post pizzas_url, params: { pizza: payload }

        follow_redirect!
        expect(response.body).to include(toppings.map { |t| t.name }.join(', '))
      end

      it 'redirects to the existing Pizza' do
        patch pizza_url(new_pizza), params: { pizza: update_attribs }

        expect(response).to redirect_to(pizza_url(new_pizza))
      end
    end

    context 'with invalid parameters' do
      it 'does not update existing Pizza' do
        expect {
          patch pizza_url(new_pizza), params: { pizza: invalid_attribs }
        }.not_to change(new_pizza, :name).from(new_pizza.name)
      end

      it 'does not allow duplicate Pizza' do
        new_pizza
        second = Pizza.create(name: 'Second Pizza')

        expect {
          patch pizza_url(new_pizza), params: { pizza: {name: second.name} }
        }.to change(Pizza, :count).by(0)
        expect(response).to be_unprocessable
      end

      it 'does not allow duplicate topppings on a Pizza' do
        new_pizza
        toppings = [{name: new_pizza.toppings.first.name}, {name: 'bacon'}]
        payload = valid_attribs.dup.merge(name: 'Meaty', toppings_attributes: toppings)

        expect {
          patch pizza_url(new_pizza), params: { pizza: payload }
        }.to change(Pizza, :count).by(0)
        expect(response).to be_unprocessable
      end

      it 'returns errors' do
        patch pizza_url(new_pizza), params: { pizza: invalid_attribs }

        expect(response).to be_unprocessable
      end
    end
  end

  describe "DELETE /destroy" do
    it 'removes the requested Pizza' do
      new_pizza

      expect {
        delete pizza_url(new_pizza)
      }.to change(Pizza, :count).by(-1)
      expect {new_pizza.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'redirects to the list of available pizzas' do
      delete pizza_url(new_pizza)

      expect(response).to redirect_to(pizzas_url)
      expect(response.body).not_to include(new_pizza.name)
    end
  end
end
