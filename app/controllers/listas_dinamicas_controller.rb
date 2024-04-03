class ListasDinamicasController < ApplicationController
  before_action :set_lista_dinamica, only: %i[show edit update destroy]
  before_action :set_filtros_donante

  # GET /lista_dinamicas
  def index
    @listas_dinamicas = ListaDinamica.all
  end

  # GET /lista_dinamicas/1
  def show; end

  # GET /lista_dinamicas/new
  def new
    @lista_dinamica = ListaDinamica.new
  end

  # GET /lista_dinamicas/1/edit
  def edit; end

  # POST /lista_dinamicas
  def create
    @lista_dinamica = ListaDinamica.new(lista_dinamica_params)

    if @lista_dinamica.save
      redirect_to lista_dinamica_path(@lista_dinamica), notice: "Lista dinamica was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lista_dinamicas/1
  def update
    if @lista_dinamica.update(lista_dinamica_params)
      redirect_to lista_dinamica_path(@lista_dinamica), notice: "Lista dinamica was successfully updated.",
                                                        status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /lista_dinamicas/1
  def destroy
    @lista_dinamica.destroy!
    redirect_to listas_dinamicas_path, notice: "Lista dinamica was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lista_dinamica
    @lista_dinamica = ListaDinamica.find(params[:id])
  end

  def set_filtros_donante
    filtros = @lista_dinamica&.filtro&.condiciones || params[:q]
    @filtros_donante = Donante.ransack(filtros)
    @filtros_donante.build_condition
  end

  # Only allow a list of trusted parameters through.
  def lista_dinamica_params
    params[:lista_dinamica][:filtro_attributes] ||= { condiciones: params[:q] } if params[:q] # FIXME
    params.require(:lista_dinamica).permit(:nombre, filtro_attributes: [:nombre, { condiciones: {} }])
  end
end
