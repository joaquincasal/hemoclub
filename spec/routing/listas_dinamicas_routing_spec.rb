require "rails_helper"

RSpec.describe ListasDinamicasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/listas_dinamicas").to route_to("listas_dinamicas#index")
    end

    it "routes to #new" do
      expect(get: "/listas_dinamicas/nueva").to route_to("listas_dinamicas#new")
    end

    it "routes to #show" do
      expect(get: "/listas_dinamicas/1").to route_to("listas_dinamicas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/listas_dinamicas/1/editar").to route_to("listas_dinamicas#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/listas_dinamicas").to route_to("listas_dinamicas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/listas_dinamicas/1").to route_to("listas_dinamicas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/listas_dinamicas/1").to route_to("listas_dinamicas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/listas_dinamicas/1").to route_to("listas_dinamicas#destroy", id: "1")
    end
  end
end
