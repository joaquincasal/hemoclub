require "rails_helper"

RSpec.describe ExclusionesTipicasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/exclusiones_tipicas").to route_to("exclusiones_tipicas#index")
    end

    it "routes to #new" do
      expect(get: "/exclusiones_tipicas/nueva").to route_to("exclusiones_tipicas#new")
    end

    it "routes to #edit" do
      expect(get: "/exclusiones_tipicas/1/editar").to route_to("exclusiones_tipicas#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/exclusiones_tipicas").to route_to("exclusiones_tipicas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/exclusiones_tipicas/1").to route_to("exclusiones_tipicas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/exclusiones_tipicas/1").to route_to("exclusiones_tipicas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/exclusiones_tipicas/1").to route_to("exclusiones_tipicas#destroy", id: "1")
    end
  end
end
