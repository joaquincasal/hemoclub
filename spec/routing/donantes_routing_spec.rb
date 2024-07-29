require "rails_helper"

RSpec.describe DonantesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/donantes").to route_to("donantes#index")
    end

    it "routes to #new" do
      expect(get: "/donantes/nueva").to route_to("donantes#new")
    end

    it "routes to #show" do
      expect(get: "/donantes/1").to route_to("donantes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/donantes/1/editar").to route_to("donantes#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/donantes").to route_to("donantes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/donantes/1").to route_to("donantes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/donantes/1").to route_to("donantes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/donantes/1").to route_to("donantes#destroy", id: "1")
    end

    it "routes to #import" do
      expect(get: "/donantes/importar").to route_to("donantes#import")
    end

    it "routes to #do_import" do
      expect(post: "/donantes/importar").to route_to("donantes#do_import")
    end

    it "routes to #import_errors" do
      expect(get: "/donantes/errores").to route_to("donantes#import_errors")
    end

    it "routes to #index_candidatos" do
      expect(get: "/donantes/candidatos").to route_to("donantes#index_candidatos")
    end

    it "routes to candidatos#create" do
      expect(post: "/donantes/candidatos").to route_to("candidatos#create")
    end

    it "routes to #suscripcion" do
      expect(get: "/donantes/suscripcion").to route_to("donantes#welcome")
    end
  end
end
