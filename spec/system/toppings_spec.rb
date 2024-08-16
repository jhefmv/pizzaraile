require "rails_helper"
require "pry"

RSpec.describe "Toppings management", type: :system do
  let(:valid_attribs) { { name: 'A new topping' } }
  let(:invalid_attribs) { valid_attribs.merge(name: '') }
  let(:new_topping) { Topping.create(valid_attribs) }
  let(:meat) { 'Meat' }

  it 'displays message when no available toppings' do
    visit toppings_path

    expect(page).to have_text('You have no toppings.')
  end

  it 'lists available toppings' do
    new_topping
    visit toppings_path

    expect(page).to have_text('Toppings')
    expect(page).to have_text('New')
    expect(page).to have_text(valid_attribs[:name])
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
    new_topping
    visit toppings_path
    click_on 'New', match: :first
    fill_in 'Name', with: valid_attribs[:name]
    click_button 'Create Topping'

    expect(page).to have_text('Name has already been taken')
  end

  it 'deletes existing topping from the list' do
    new_topping
    visit toppings_path

    expect(page).to have_text(valid_attribs[:name])

    click_on 'Delete', match: :first

    expect(page).not_to have_text(valid_attribs[:name])
  end

  it 'edits existing topping from the list' do
    new_topping
    visit toppings_path

    expect(page).to have_text(valid_attribs[:name])

    click_on 'Edit', match: :first

    expect(page).to have_text('Edit Topping')

    fill_in 'Name', with: meat
    click_button 'Update Topping'

    expect(page).to have_text(meat)
    expect(page).not_to have_text(valid_attribs[:name])
  end

  it 'prevents updating a duplicate topping' do
    duplicate_topping = 'Second topping'
    new_topping
    Topping.create(name: duplicate_topping)
    visit toppings_path

    expect(page).to have_text(duplicate_topping)
    expect(page).to have_text(valid_attribs[:name])

    click_on 'Edit', match: :first
    fill_in 'Name', with: duplicate_topping
    click_button 'Update Topping'

    expect(page).to have_text('Name has already been taken')
  end
end