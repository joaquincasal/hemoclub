class DifusionesController < ApplicationController
  before_action :set_difusion, only: %i[show edit update destroy]

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
      redirect_to @difusion, notice: "Difusion was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /difusiones/1
  def update
    if @difusion.update(difusion_params)
      redirect_to @difusion, notice: "Difusion was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /difusiones/1
  def destroy
    @difusion.destroy!
    redirect_to difusiones_url, notice: "Difusion was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_difusion
    @difusion = Difusion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def difusion_params
    params.require(:difusion).permit(:nombre, :lista_dinamica_id, :plantilla_id)
  end
end
