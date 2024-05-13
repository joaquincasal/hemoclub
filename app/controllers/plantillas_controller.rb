class PlantillasController < ApplicationController
  before_action :set_plantilla, only: %i[show edit update destroy]

  # GET /plantillas
  def index
    @plantillas = Plantilla.all
  end

  # GET /plantillas/1
  def show; end

  # GET /plantillas/new
  def new
    @plantilla = Plantilla.new
  end

  # GET /plantillas/1/edit
  def edit; end

  # POST /plantillas
  def create
    @plantilla = Plantilla.new(plantilla_params)

    if @plantilla.save
      redirect_to @plantilla, notice: "Plantilla creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plantillas/1
  def update
    if @plantilla.update(plantilla_params)
      redirect_to @plantilla, notice: "Plantilla actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /plantillas/1
  def destroy
    @plantilla.destroy!
    redirect_to plantillas_url, notice: "Plantilla eliminada exitosamente.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plantilla
    @plantilla = Plantilla.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def plantilla_params
    params.require(:plantilla).permit(:nombre, :contenido, :reutilizable, :encabezado_id, :firma_id, :asunto)
  end
end
