require "rails_helper"

RSpec.describe InformesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/informes").to route_to("informes#index")
    end
  end
end
