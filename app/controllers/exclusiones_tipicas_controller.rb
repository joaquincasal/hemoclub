class ExclusionesTipicasController < ApplicationController
  before_action :set_exclusion_tipica, only: %i[edit update destroy]

  # GET /exclusiones_tipicas
  def index
    @exclusiones_tipicas = ExclusionTipica.order(:duracion)
  end

  # GET /exclusiones_tipicas/new
  def new
    @exclusion_tipica = ExclusionTipica.new
  end

  # GET /exclusiones_tipicas/1/edit
  def edit; end

  # POST /exclusiones_tipicas
  def create
    @exclusion_tipica = ExclusionTipica.new(exclusion_tipica_params)

    if @exclusion_tipica.save
      redirect_to exclusiones_tipicas_url, notice: "Exclusión creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exclusiones_tipicas/1
  def update
    if @exclusion_tipica.update(exclusion_tipica_params)
      redirect_to exclusiones_tipicas_url, notice: "Exclusión actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /exclusiones_tipicas/1
  def destroy
    @exclusion_tipica.destroy!
    redirect_to exclusiones_tipicas_url, notice: "Exclusión eliminada exitosamente.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exclusion_tipica
    @exclusion_tipica = ExclusionTipica.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def exclusion_tipica_params
    params.require(:exclusion_tipica).permit(:duracion, :motivo)
  end
end
