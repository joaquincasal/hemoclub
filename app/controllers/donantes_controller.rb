class DonantesController < ApplicationController
  include Pagy::Backend

  before_action :set_donante, only: %i[show edit update destroy]

  # GET /donantes
  def index
    @pagy, @donantes = pagy(Donante.all)
  end

  # GET /donantes/1
  def show; end

  # GET /donantes/new
  def new
    @donante = Donante.new
  end

  # GET /donantes/1/edit
  def edit; end

  # POST /donantes
  def create
    @donante = Donante.new(donante_params)

    if @donante.save
      redirect_to @donante, notice: "Donante creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /donantes/1
  def update
    if @donante.update(donante_params)
      redirect_to @donante, notice: "Donante actualizado exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /donantes/1
  def destroy
    @donante.destroy!
    redirect_to donantes_url, notice: "Donante eliminado exitosamente.", status: :see_other
  end

  def import; end

  def do_import
    Importador.new.importar(params[:archivo].path)
    redirect_to donantes_url, notice: "Donantes importados exitosamente."
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
