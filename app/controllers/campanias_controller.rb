class CampaniasController < ApplicationController
  before_action :set_campania, only: %i[show edit update destroy send_now schedule]

  # GET /campanias
  def index
    @campanias = Campania.order(:nombre)
  end

  # GET /campanias/1
  def show
    total = Donante.joins(:interacciones).where(interacciones: { comunicacion_id: @campania.id })
    filtro = FiltroPorInteraccion.new(atributo: @campania.id)
    volvieron = filtro.aplicar
    @efectividad = { "Donaron" => volvieron.count, "No donaron" => total.count - volvieron.count }
  end

  # GET /campanias/new
  def new
    @campania = Campania.new
  end

  # GET /campanias/1/edit
  def edit; end

  # POST /campanias
  def create
    @campania = Campania.new(campania_params)

    if @campania.save
      redirect_to @campania, notice: "Campaña creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /campanias/1
  def update
    if @campania.update(campania_params)
      redirect_to @campania, notice: "Campaña actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /campanias/1
  def destroy
    @campania.destroy!
    redirect_to campanias_url, notice: "Campaña eliminada exitosamente.", status: :see_other
  end

  def send_now
    @campania.enviar
    redirect_to @campania, notice: "Campaña enviada exitosamente."
  end

  def schedule
    @campania.programar_envio(Time.zone.parse(params[:fecha]))
    redirect_to @campania, notice: "Campaña programada exitosamente."
  end

  def cancel
    ejecucion = Ejecucion.find(params[:id])
    campania = ejecucion.comunicacion
    ejecucion.cancelar_envio
    redirect_to campania, notice: "Envío cancelado exitosamente."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_campania
    @campania = Campania.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def campania_params
    params.require(:campania).permit(:nombre, :lista_id, :plantilla_id, :remitente)
  end
end
