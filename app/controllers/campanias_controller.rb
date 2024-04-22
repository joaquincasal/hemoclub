class CampaniasController < ApplicationController
  before_action :set_campania, only: %i[show edit update destroy]

  # GET /campanias
  def index
    @campanias = Campania.all
  end

  # GET /campanias/1
  def show; end

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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_campania
    @campania = Campania.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def campania_params
    params.require(:campania).permit(:nombre, :activa, :lista_id, :plantilla_id)
  end
end
