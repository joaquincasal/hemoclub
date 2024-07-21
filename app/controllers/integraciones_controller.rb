class IntegracionesController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_usuario!
  before_action :validar_token

  private

  def validar_token
    head :unauthorized if ENV["WEBHOOK_KEY"] != params[:key]
  end
end
