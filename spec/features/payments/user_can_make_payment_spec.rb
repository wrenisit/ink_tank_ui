require 'rails_helper'

def stub_omniauth
   OmniAuth.config.test_mode = true
   OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
     provider: "google",
      uid: "12345678910",
      info: {
        email: "example@example.com",
        first_name: "first",
        last_name: "last"
      },
      credentials: {
        token: "abcdefg12345",
        refresh_token: "12345abcdefg",
        expires_at: DateTime.now,
      }
      })
end

RSpec.describe "as an artist" do
  it "can initiate a payment" do
    # expect(current_path).to eq(new_shop_path)
    # expect(page).to have_content('Enter Shop Information')
    #
    # fill_in :_shops_zip_code, with: '80202'
    # expect(page).to_not have_field(:streetAddress)
    # expect(page).to_not have_field(:city)
    # expect(page).to_not have_field(:phone)
    #
    # click_on('Search For Shops')
    # expect(page).to have_content('No shops found in that zipcode. Please create one.')
    #
    # fill_in :shop_name, with: 'default'
    # fill_in :shop_street_address, with: '123 Main Street'
    # fill_in :shop_city, with: 'Denver'
    # fill_in :shop_phone_number, with: '123456789'
    #
    # click_on('Next')
    #
    # fill_in :user_name, with: 'John'
    # fill_in :user_price_per_hour, with: 100.00
    # fill_in :user_bio, with: 'I love tattoos!'
    #
    # click_on('Finish creating profile')
    #
    # expect(page).to have_content('Name: John')
    # expect(page).to have_content('Hourly rate: $100.00')
    # expect(page).to have_content('Bio: I love tattoos!')
    #
    # expect(current_path).to eq('/profile')
    # expect(page).to have_content('Registration complete!')
    # # shop = Shop.create(name: 'Default shop', street_address: '123 Main', city: 'Denver', zip: '80206', phone_number: '123456789')
    # user = User.last

    stub_omniauth
    user = create(:user, uid: "12345678910", token: 'token', login: 'example@example.com')
    visit root_path

    click_on("Login with Google")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/profile'
    click_on "Get Paid"
    expect(current_path).to eq('/payments/new')
    fill_in :title, with: 'Mermaid Tattoo'
    fill_in :amount, with: '200'
    fill_in :description, with: 'Tattoo complete, final payment'
    click_on 'Submit Payment'
    expect(current_path).to eq('/profile')
    expect(page).to have_content('Charge complete')
  end
end