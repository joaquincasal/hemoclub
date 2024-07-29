require "rails_helper"

RSpec.describe CampaniasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/campanias").to route_to("campanias#index")
    end

    it "routes to #new" do
      expect(get: "/campanias/nueva").to route_to("campanias#new")
    end

    it "routes to #show" do
      expect(get: "/campanias/1").to route_to("campanias#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/campanias/1/editar").to route_to("campanias#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/campanias").to route_to("campanias#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/campanias/1").to route_to("campanias#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/campanias/1").to route_to("campanias#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/campanias/1").to route_to("campanias#destroy", id: "1")
    end

    it "routes to #send_now" do
      expect(post: "/campanias/1/enviar").to route_to("campanias#send_now", id: "1")
    end

    it "routes to #schedule" do
      expect(post: "/campanias/1/programar").to route_to("campanias#schedule", id: "1")
    end

    it "routes to #cancel" do
      expect(delete: "/campanias/1/cancelar").to route_to("campanias#cancel", id: "1")
    end
  end
end
