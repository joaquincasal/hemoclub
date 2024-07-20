require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/campanias", type: :request do
  include Devise::Test::IntegrationHelpers

  # This should return the minimal set of attributes required to create a valid
  # Campania. As you add validations to Campania, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { nombre: "una campaña", lista_id: create(:lista).id, plantilla_id: create(:plantilla).id }
  end

  let(:invalid_attributes) do
    { nombre: "" }
  end

  before { sign_in Usuario.new }

  describe "GET /index" do
    it "renders a successful response" do
      Campania.create! valid_attributes
      get campanias_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      campania = Campania.create! valid_attributes
      get campania_url(campania)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_campania_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      campania = Campania.create! valid_attributes
      get edit_campania_url(campania)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Campania" do
        expect do
          post campanias_url, params: { campania: valid_attributes }
        end.to change(Campania, :count).by(1)
      end

      it "redirects to the created campania" do
        post campanias_url, params: { campania: valid_attributes }
        expect(response).to redirect_to(campania_url(Campania.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Campania" do
        expect do
          post campanias_url, params: { campania: invalid_attributes }
        end.not_to change(Campania, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post campanias_url, params: { campania: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { nombre: "otra campania" }
      end

      it "updates the requested campania" do
        campania = Campania.create! valid_attributes
        patch campania_url(campania), params: { campania: new_attributes }
        campania.reload
        expect(campania.nombre).to eq new_attributes[:nombre]
      end

      it "redirects to the campania" do
        campania = Campania.create! valid_attributes
        patch campania_url(campania), params: { campania: new_attributes }
        campania.reload
        expect(response).to redirect_to(campania_url(campania))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        campania = Campania.create! valid_attributes
        patch campania_url(campania), params: { campania: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested campania" do
      campania = Campania.create! valid_attributes
      expect do
        delete campania_url(campania)
      end.to change(Campania, :count).by(-1)
    end

    it "redirects to the campanias list" do
      campania = Campania.create! valid_attributes
      delete campania_url(campania)
      expect(response).to redirect_to(campanias_url)
    end
  end
end
