require "rails_helper"

RSpec.describe DifusionesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/difusiones").to route_to("difusiones#index")
    end

    it "routes to #new" do
      expect(get: "/difusiones/nueva").to route_to("difusiones#new")
    end

    it "routes to #show" do
      expect(get: "/difusiones/1").to route_to("difusiones#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/difusiones/1/editar").to route_to("difusiones#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/difusiones").to route_to("difusiones#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/difusiones/1").to route_to("difusiones#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/difusiones/1").to route_to("difusiones#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/difusiones/1").to route_to("difusiones#destroy", id: "1")
    end
  end
end
