class ClinicasController < ApplicationController
  before_action :set_clinica, only: %i[edit update]

  # GET /clinicas
  def index
    @clinicas = Clinica.all
  end

  # GET /clinicas/new
  def new
    @clinica = Clinica.new
  end

  # GET /clinicas/1/edit
  def edit; end

  # POST /clinicas
  def create
    @clinica = Clinica.new(clinica_params)

    if @clinica.save
      redirect_to clinicas_url, notice: "Clinica creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clinicas/1
  def update
    if @clinica.update(clinica_params)
      redirect_to clinicas_url, notice: "Clinica actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_clinica
    @clinica = Clinica.find(params[:codigo])
  end

  # Only allow a list of trusted parameters through.
  def clinica_params
    params.require(:clinica).permit(:codigo, :nombre)
  end
end
