class DonantesController < ApplicationController
  include Pagy::Backend

  before_action :set_donante, only: %i[show edit update destroy]

  # GET /donantes
  def index
    @filtros_donante = Donante.ransack(params[:q])
    donantes = @filtros_donante.result.includes(:donaciones)
    # @filtros_donante.build_condition
    @pagy, @donantes = pagy(donantes)
  end

  def search
    index
    render :index
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
    sin_errores = Importador.new.importar(params[:archivo].path)
    return redirect_to donantes_url, notice: "Donantes importados exitosamente." if sin_errores

    flash[:alert] =
      'Algunas filas tuvieron errores y no se importaron. Click <a href="/donantes/errores">aquí</a> para descargar
        archivo con las filas con errores. Corregir los errores y volver a importar'
    redirect_to importar_donantes_url
  end

  def import_errors
    send_file(Rails.root.join("errores.csv"))
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

  def sort_column
    %w[nombre tipo_donante donaciones.fecha].include?(params[:orden]) ? params[:orden] : "donaciones.fecha"
  end

  def sort_direction
    %w[asc desc].include?(params[:direccion]) ? params[:direccion] : "desc"
  end
end
