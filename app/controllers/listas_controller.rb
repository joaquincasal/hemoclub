class ListasController < ApplicationController
  before_action :set_lista, only: %i[show edit update destroy actualizar_donantes]

  # GET /listas
  def index
    @listas = Lista.all
  end

  # GET /listas/1
  def show; end

  # GET /listas/new
  def new
    case params[:tipo]
    when 'estatica'
      @lista = ListaEstatica.new(filtro: Filtro.new(parametros: {}))
    when 'dinamica'
      @lista = ListaDinamica.new(filtro: Filtro.new(parametros: {}))
    end
  end

  # GET /listas/1/edit
  def edit; end

  # POST /listas
  def create
    parametros = lista_params
    tipo = parametros[:type]
    case tipo
    when ListaEstatica.name
      @lista = ListaEstatica.new(parametros)
      @lista.set_donantes
    when ListaDinamica.name
      @lista = ListaDinamica.new(parametros)
    end

    if @lista.save
      redirect_to lista_path(@lista), notice: "Lista creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /listas/1
  def update
    if @lista.update(lista_params)
      redirect_to lista_path(@lista), notice: "Lista actualizada exitosamente.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /listas/1
  def destroy
    @lista.destroy!
    redirect_to listas_path, notice: "Lista eliminada exitosamente.", status: :see_other
  end

  def actualizar_donantes
    @lista.set_donantes
    redirect_to lista_path(@lista), notice: "Donantes actualizados exitosamente.", status: :see_other
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
