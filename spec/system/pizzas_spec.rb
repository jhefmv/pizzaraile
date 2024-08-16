require "rails_helper"

RSpec.describe "Pizza management", type: :system do
  def visit_pizza_menu
    visit root_path
    click_on 'Pizzas', match: :first
  end

  let(:beef) { 'Beef' }
  let(:ham) { 'Ham' }
  let(:meat) { 'Meat' }
  let(:valid_attribs) {
    {
      name: 'A new pizza',
      toppings_attributes: [{name: 'olives'}]
    }
  }
  let(:new_pizza) { Pizza.create(valid_attribs) }

  it 'displays message when no available pizza' do
    visit_pizza_menu

    expect(page).to have_text('You have no pizzas.')
  end

  it 'lists available pizzas and their toppings' do
    new_pizza
    visit_pizza_menu

    expect(page).to have_text('Pizzas')
    expect(page).to have_text('New')
    expect(page).to have_text(valid_attribs[:name])
    expect(page).to have_text(valid_attribs[:toppings_attributes].map { |t| t[:name] }.join(', '))
  end

  it 'creates new pizza' do
    Topping.create(name: beef)
    
    visit_pizza_menu
    click_on 'New', match: :first

    expect(page).to have_text('New Pizza')

    fill_in 'Name', with: meat
    uncheck beef
    click_button 'Create Pizza'

    expect(page).to have_text(meat)
    expect(page).not_to have_text(beef)
  end

  it 'creates new pizza with toppings' do
    [beef, ham].each { |t| Topping.create(name: t) }

    visit_pizza_menu
    click_on 'New', match: :first

    fill_in 'Name', with: meat
    check beef
    click_button 'Create Pizza'

    expect(page).to have_text(meat)
    expect(page).to have_text(beef)
    expect(page).not_to have_text(ham)
  end

  it 'prevents creation of dupplicate pizza' do
    new_pizza
    visit_pizza_menu

    click_on 'New', match: :first
    fill_in 'Name', with: valid_attribs[:name]
    click_button 'Create Pizza'

    expect(page).to have_text('Name has already been taken')
  end

  it 'deletes existing pizza from the list' do
    new_pizza
    visit_pizza_menu

    expect(page).to have_text(valid_attribs[:name])

    click_on 'Delete', match: :first

    expect(page).not_to have_text(valid_attribs[:name])
  end

  it 'edits existing pizza from the list' do
    new_pizza
    visit_pizza_menu

    expect(page).to have_text(valid_attribs[:name])

    click_on 'Edit', match: :first

    expect(page).to have_text('Edit Pizza')

    fill_in 'Name', with: meat
    click_button 'Update Pizza'

    expect(page).to have_text(meat)
    expect(page).not_to have_text(valid_attribs[:name])
  end

  it 'update toppings on existing pizza' do
    existing_topping = valid_attribs[:toppings_attributes].first[:name]
    second_topping = 'Green Pepper'
    Topping.create(name: second_topping)

    new_pizza
    visit_pizza_menu
    click_on 'Edit', match: :first
    uncheck existing_topping
    check second_topping
    click_button 'Update Pizza'

    expect(page).to have_text(new_pizza.reload.topping_names)
    expect(page).not_to have_text(existing_topping)
  end

  it 'prevents updating a duplicate pizza' do
    new_pizza
    second_pizza = 'Second pizza'
    Pizza.create(name: second_pizza)

    visit_pizza_menu

    expect(page).to have_text(second_pizza)
    expect(page).to have_text(valid_attribs[:name])

    click_on 'Edit', match: :first
    fill_in 'Name', with: second_pizza
    click_button 'Update Pizza'

    expect(page).to have_text('Name has already been taken')
  end
end