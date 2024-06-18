# frozen_string_literal: true

class ListasReflex < ApplicationReflex
  delegate :view_context, :lista_params, to: :controller

  def filtro_seleccionado
    lista = create_lista
    form = ActionView::Helpers::FormBuilder.new(:lista, lista, view_context, {})
    filtro = element.value
    id = element["data-id"]
    morph "#atributo-#{id}",
          render(partial: "filtros/atributos", locals: { filtro: filtro.constantize, form: form, id: id })
    morph "#operador-#{id}", ""
    morph "#valor-#{id}", ""
  end

  def atributo_seleccionado
    lista = create_lista
    form = ActionView::Helpers::FormBuilder.new(:lista, lista, view_context, {})
    filtro = element["data-filtro"]
    atributo = element.value
    id = element["data-id"]
    tipo_valor = filtro.constantize.valores(atributo)
    morph "#operador-#{id}",
          render(partial: "filtros/operadores",
                 locals: { form: form, id: id, filtro: filtro.constantize, atributo: atributo })
    return unless filtro != "FiltroPorInteraccion"

    morph "#valor-#{id}", render(partial: "filtros/valor",
                                 locals: { form: form, id: id, filtro: filtro.constantize, info_valor: tipo_valor })
  end

  def agregar_filtro
    morph :nothing
    session[:count] = session[:count].to_i + 1
    contador = session[:count]
    lista = create_lista
    form = ActionView::Helpers::FormBuilder.new(:lista, lista, view_context, {})
    cable_ready.append(selector: "#filtros",
                       html: render(partial: "filtros/filtros", locals: { form: form, id: contador, filtro: nil }))
  end

  def borrar_filtro
    morph :nothing
    id = element["data-id"]
    cable_ready.remove(selector: "#filtro-#{id}")
  end

  def create_lista
    if params[:id]
      case params[:tipo]
      when 'estatica'
        ListaEstatica.find(params[:id])
      when 'dinamica'
        ListaDinamica.find(params[:id])
      end
    else
      case params[:tipo]
      when 'estatica'
        ListaEstatica.new(lista_params)
      when 'dinamica'
        ListaDinamica.new(lista_params)
      end
    end
  end
end
