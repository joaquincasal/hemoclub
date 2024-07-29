require "rails_helper"

RSpec.describe InformesController, type: :routing do
  describe "routing" do
    it "routes to #update" do
      expect(post: "/interacciones").to route_to("interacciones#update")
    end
  end
end
