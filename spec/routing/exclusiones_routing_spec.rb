require "rails_helper"

RSpec.describe ExclusionesController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/donantes/1/exclusiones/nueva").to route_to("exclusiones#new", donante_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/donantes/1/exclusiones/1/editar").to route_to("exclusiones#edit", id: "1", donante_id: "1")
    end

    it "routes to #create" do
      expect(post: "/donantes/1/exclusiones").to route_to("exclusiones#create", donante_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/donantes/1/exclusiones/1").to route_to("exclusiones#update", id: "1", donante_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/donantes/1/exclusiones/1").to route_to("exclusiones#update", id: "1", donante_id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/donantes/1/exclusiones/1").to route_to("exclusiones#destroy", id: "1", donante_id: "1")
    end
  end
end
