class DifusionesController < ApplicationController
  before_action :set_difusion, only: %i[show edit update destroy send_now schedule]

  # GET /difusiones
  def index
    @difusiones = Difusion.all
  end

  # GET /difusiones/1
  def show; end

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
    # TODO: difusion.enviar
  end

  def schedule
    EnviarDifusionJob.set(wait_until: Time.zone.parse(params[:fecha])).perform_later(@difusion.id)
  end

  def cancel
    GoodJob::Execution.destroy(params[:id])
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
