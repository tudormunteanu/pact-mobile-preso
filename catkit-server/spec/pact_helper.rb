require 'pact/provider/rspec'

Pact.service_provider "CatKit Service" do

  honours_pact_with 'CatKit iOS App' do
    pact_uri './pacts/ios-app/ios-app-guacamole-mobile-bff.json'
  end
end

Pact.provider_states_for "CatKit iOS App" do

  provider_state "We are out of cat food" do
    set_up do
      FoodRepository.amount_of_food = 0
    end
  end
end
