require "rails_helper"
require "pry"

RSpec.describe "Toppings management", type: :system do
  def create_new_topping(attribs)
    Topping.create(attribs)
  end

  let(:valid_attribs) { { name: 'A new topping' } }
  let(:meat) { 'Meat' }

  it 'displays message when no available toppings' do
    visit toppings_path

    expect(page).to have_text('You have no toppings.')
  end

  it 'lists available toppings' do
    new_topping = create_new_topping(valid_attribs)
    visit toppings_path

    expect(page).to have_text('Toppings')
    expect(page).to have_text('New')
    expect(page).to have_text(new_topping.name)
  end

  it 'creates new topping' do
    visit toppings_path
    click_on 'New', match: :first

    expect(page).to have_text('New Topping')

    fill_in 'Name', with: meat
    click_button 'Create Topping'

    expect(page).to have_text(meat)
  end

  it 'prevents creation of dupplicate topping' do
    new_topping = create_new_topping(valid_attribs)
    visit toppings_path
    click_on 'New', match: :first
    fill_in 'Name', with: new_topping.name
    click_button 'Create Topping'

    expect(page).to have_text('Name has already been taken')
  end

  it 'deletes existing topping from the list' do
    new_topping = create_new_topping(valid_attribs)
    visit toppings_path

    expect(page).to have_text(new_topping.name)

    click_on 'Delete', match: :first

    expect(page).not_to have_text(new_topping.name)
  end

  it 'edits existing topping from the list' do
    new_topping = create_new_topping(valid_attribs)
    visit toppings_path

    expect(page).to have_text(new_topping.name)

    click_on 'Edit', match: :first

    expect(page).to have_text('Edit Topping')

    fill_in 'Name', with: meat
    click_button 'Update Topping'

    expect(page).to have_text(meat)
    expect(page).not_to have_text(new_topping.name)
  end

  it 'prevents updating a duplicate topping' do
    first_topping = create_new_topping(valid_attribs)
    second_topping = create_new_topping(name: 'Second topping')
    visit toppings_path

    expect(page).to have_text(second_topping.name)
    expect(page).to have_text(first_topping.name)

    click_on 'Edit', match: :first
    fill_in 'Name', with: second_topping.name
    click_button 'Update Topping'

    expect(page).to have_text('Name has already been taken')
  end
end