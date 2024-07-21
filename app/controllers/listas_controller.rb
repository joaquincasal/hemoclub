class ListasController < ApplicationController
  before_action :set_lista, only: %i[show edit update destroy]

  # GET /listas
  def index
    @listas = Lista.order(:nombre)
  end

  # GET /listas/1
  def show; end

  # GET /listas/new
  def new
    @lista = Lista.new(filtro: Filtro.new(parametros: {}))
  end

  # GET /listas/1/edit
  def edit; end

  # POST /listas
  def create
    @lista = Lista.new(lista_params)
    if @lista.save
      redirect_to @lista, notice: "Lista creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /listas/1
  def update
    if @lista.update(lista_params)
      redirect_to @lista, notice: "Lista actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /listas/1
  def destroy
    @lista.destroy!
    redirect_to listas_path, notice: "Lista eliminada exitosamente.", status: :see_other
  end

  # Only allow a list of trusted parameters through.
  def lista_params
    params.require(:lista).permit(:nombre, :type,
                                  filtro_attributes: [{ parametros: [:tipo, :atributo, :operador, :valor] }])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lista
    @lista = Lista.find(params[:id])
  end
end
