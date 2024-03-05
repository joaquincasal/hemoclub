class ExclusionesController < ApplicationController
  before_action :set_exclusion, only: %i[edit update destroy]
  before_action :set_donante

  # GET /exclusiones/new
  def new
    @exclusion = Exclusion.new
  end

  # GET /exclusiones/1/edit
  def edit; end

  # POST /exclusiones
  def create
    @exclusion = Exclusion.new(exclusion_params)

    if @exclusion.save
      redirect_to donante_path(@donante), notice: "Exclusion creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /exclusiones/1
  def update
    if @exclusion.update(exclusion_params)
      redirect_to donante_path(@donante), notice: "Exclusion actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /exclusiones/1
  def destroy
    @exclusion.destroy!
    redirect_to donante_path(@donante), notice: "Exclusion eliminada exitosamente.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exclusion
    @exclusion = Exclusion.find(params[:id])
  end

  def set_donante
    @donante = Donante.find(params[:donante_id])
  end

  # Only allow a list of trusted parameters through.
  def exclusion_params
    params.require(:exclusion).permit(:fecha_inicio, :fecha_fin, :motivo, :donante_id)
  end
end
