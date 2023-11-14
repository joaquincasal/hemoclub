require "rails_helper"

RSpec.describe DonantesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/donantes").to route_to("donantes#index")
    end

    it "routes to #new" do
      expect(get: "/donantes/new").to route_to("donantes#new")
    end

    it "routes to #show" do
      expect(get: "/donantes/1").to route_to("donantes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/donantes/1/edit").to route_to("donantes#edit", id: "1")
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
  end
end
