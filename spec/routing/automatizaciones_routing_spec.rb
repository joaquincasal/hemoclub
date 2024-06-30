require "rails_helper"

RSpec.describe AutomatizacionesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/automatizaciones").to route_to("automatizaciones#index")
    end

    it "routes to #new" do
      expect(get: "/automatizaciones/nueva").to route_to("automatizaciones#new")
    end

    it "routes to #show" do
      expect(get: "/automatizaciones/1").to route_to("automatizaciones#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/automatizaciones/1/editar").to route_to("automatizaciones#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/automatizaciones").to route_to("automatizaciones#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/automatizaciones/1").to route_to("automatizaciones#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/automatizaciones/1").to route_to("automatizaciones#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/automatizaciones/1").to route_to("automatizaciones#destroy", id: "1")
    end
  end
end
