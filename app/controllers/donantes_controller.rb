class DonantesController < ApplicationController
  before_action :set_donante, only: %i[ show edit update destroy ]

  # GET /donantes
  def index
    @donantes = Donante.all
  end

  # GET /donantes/1
  def show
  end

  # GET /donantes/new
  def new
    @donante = Donante.new
  end

  # GET /donantes/1/edit
  def edit
  end

  # POST /donantes
  def create
    @donante = Donante.new(donante_params)

    if @donante.save
      redirect_to @donante, notice: "Donante was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /donantes/1
  def update
    if @donante.update(donante_params)
      redirect_to @donante, notice: "Donante was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /donantes/1
  def destroy
    @donante.destroy!
    redirect_to donantes_url, notice: "Donante was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_donante
    @donante = Donante.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def donante_params
    params.require("donante").permit(:nombre, :segundo_nombre, :apellidos, :tipo_documento, :numero_documento,
                                     :sexo, :fecha_nacimiento, :tipo_donante, :telefono, :correo_electronico,
                                     :ocupacion, :grupo_sanguineo, :factor, :direccion, :localidad,
                                     :provincia, :pais, :codigo_postal)
  end
end
