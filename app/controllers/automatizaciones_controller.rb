class AutomatizacionesController < ApplicationController
  before_action :set_automatizacion, only: %i[show edit update destroy]

  # GET /automatizaciones
  def index
    @automatizaciones = Automatizacion.order(:nombre)
  end

  # GET /automatizaciones/1
  def show; end

  # GET /automatizaciones/new
  def new
    @automatizacion = Automatizacion.new
  end

  # GET /automatizaciones/1/edit
  def edit; end

  # POST /automatizaciones
  def create
    @automatizacion = Automatizacion.new(automatizacion_params)

    if @automatizacion.save
      redirect_to @automatizacion, notice: "Automatización creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /automatizaciones/1
  def update
    if @automatizacion.update(automatizacion_params)
      redirect_to @automatizacion, notice: "Automatización actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /automatizaciones/1
  def destroy
    @automatizacion.destroy!
    redirect_to automatizaciones_url, notice: "Automatización eliminada exitosamente.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_automatizacion
    @automatizacion = Automatizacion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def automatizacion_params
    params.require(:automatizacion).permit(:nombre, :activa, :lista_id, :plantilla_id)
  end
end
