require "rails_helper"

RSpec.describe ListasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/listas").to route_to("listas#index")
    end

    it "routes to #new" do
      expect(get: "/listas/nueva").to route_to("listas#new")
    end

    it "routes to #show" do
      expect(get: "/listas/1").to route_to("listas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/listas/1/editar").to route_to("listas#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/listas").to route_to("listas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/listas/1").to route_to("listas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/listas/1").to route_to("listas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/listas/1").to route_to("listas#destroy", id: "1")
    end
  end
end
