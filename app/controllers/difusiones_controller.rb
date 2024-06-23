class DifusionesController < ApplicationController
  before_action :set_difusion, only: %i[show edit update destroy send_now schedule]

  # GET /difusiones
  def index
    @difusiones = Difusion.all
  end

  # GET /difusiones/1
  def show
    total = Donacion.select("donaciones.donante_id").distinct
                    .joins("INNER JOIN interacciones ON interacciones.donante_id = donaciones.donante_id")
                    .where(interacciones: { ejecutable_id: @difusion.id, ejecutable_type: @difusion.class.name })
    volvieron = total.where("donaciones.fecha >= interacciones.fecha")
                     .where("donaciones.fecha <= interacciones.fecha + interval '2 months'")
    @efectividad = { "Donaron" => volvieron.count, "No donaron" => total.count - volvieron.count }
  end

  # GET /difusiones/new
  def new
    @difusion = Difusion.new
  end

  # GET /difusiones/1/edit
  def edit; end

  # POST /difusiones
  def create
    @difusion = Difusion.new(difusion_params)

    if @difusion.save
      redirect_to @difusion, notice: "Difusion creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /difusiones/1
  def update
    if @difusion.update(difusion_params)
      redirect_to @difusion, notice: "Difusion actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /difusiones/1
  def destroy
    @difusion.destroy!
    redirect_to difusiones_url, notice: "Difusion eliminada exitosamente.", status: :see_other
  end

  def send_now
    @difusion.enviar
    redirect_to @difusion, notice: "Difusion enviada exitosamente."
  end

  def schedule
    @difusion.programar_envio(Time.zone.parse(params[:fecha]))
    redirect_to @difusion, notice: "Difusion programada exitosamente."
  end

  def cancel
    ejecucion = Ejecucion.find(params[:id])
    difusion = ejecucion.ejecutable
    ejecucion.cancelar_envio
    redirect_to difusion, notice: "Difusion cancelada exitosamente."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_difusion
    @difusion = Difusion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def difusion_params
    params.require(:difusion).permit(:nombre, :lista_id, :plantilla_id)
  end
end
