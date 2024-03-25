require "rails_helper"

RSpec.describe PlantillasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/plantillas").to route_to("plantillas#index")
    end

    it "routes to #new" do
      expect(get: "/plantillas/nueva").to route_to("plantillas#new")
    end

    it "routes to #show" do
      expect(get: "/plantillas/1").to route_to("plantillas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/plantillas/1/editar").to route_to("plantillas#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/plantillas").to route_to("plantillas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/plantillas/1").to route_to("plantillas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/plantillas/1").to route_to("plantillas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/plantillas/1").to route_to("plantillas#destroy", id: "1")
    end
  end
end
