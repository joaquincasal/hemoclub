require "rails_helper"

RSpec.describe ClinicasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/clinicas").to route_to("clinicas#index")
    end

    it "routes to #new" do
      expect(get: "/clinicas/nueva").to route_to("clinicas#new")
    end

    it "routes to #edit" do
      expect(get: "/clinicas/1/editar").to route_to("clinicas#edit", codigo: "1")
    end

    it "routes to #create" do
      expect(post: "/clinicas").to route_to("clinicas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/clinicas/1").to route_to("clinicas#update", codigo: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/clinicas/1").to route_to("clinicas#update", codigo: "1")
    end
  end
end
