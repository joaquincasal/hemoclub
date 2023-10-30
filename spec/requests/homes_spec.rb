require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /home" do
    it "succeeds" do
      get home_url
      expect(response).to have_http_status(200)
    end
  end
end
