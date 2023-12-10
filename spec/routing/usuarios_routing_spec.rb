require "rails_helper"

RSpec.describe UsuariosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/usuarios").to route_to("usuarios#index")
    end

    it "routes to #destroy" do
      expect(delete: "/usuarios/1").to route_to("usuarios#destroy", id: "1")
    end
  end
end
