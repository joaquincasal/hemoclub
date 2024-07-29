# frozen_string_literal: true

class ListasReflex < ApplicationReflex
  delegate :view_context, :lista_params, to: :controller

  def filtro_seleccionado
    filtro = element.value.constantize
    return unless filtro.atributo?

    lista = create_lista
    form = ActionView::Helpers::FormBuilder.new(:lista, lista, view_context, {})
    id = element["data-id"]
    morph "#atributo-#{id}",
          render(partial: "filtros/atributos", locals: { filtro: filtro, form: form, id: id })
            .gsub("&lt;/div&gt;", "")
    morph "#operador-#{id}", ""
    morph "#valor-#{id}", ""
  end

  def atributo_seleccionado
    filtro = element["data-filtro"].constantize
    unless filtro.operador?
      morph :nothing
      return
    end

    form = ActionView::Helpers::FormBuilder.new(:lista, create_lista, view_context, {})
    atributo = element.value
    id = element["data-id"]
    morph "#operador-#{id}",
          render(partial: "filtros/operadores", locals: { form: form, id: id, filtro: filtro, atributo: atributo })
            .gsub("&lt;/div&gt;", "")

    morph "#valor-#{id}", render(partial: "filtros/valor",
                                 locals: { form: form, id: id, filtro: filtro, info_valor: filtro.valores(atributo) })
      .gsub("&lt;/div&gt;", "")
  end

  def agregar_filtro
    morph :nothing
    session[:count] = session[:count].to_i + 1
    contador = session[:count]
    lista = create_lista
    form = ActionView::Helpers::FormBuilder.new(:lista, lista, view_context, {})
    cable_ready.append(selector: "#filtros",
                       html: render(partial: "filtros/filtros", locals: { form: form, id: contador, filtro: nil })
                               .gsub("&lt;/div&gt;", ""))
  end

  def borrar_filtro
    morph :nothing
    id = element["data-id"]
    cable_ready.remove(selector: "#filtro-#{id}")
  end

  def create_lista
    params[:id] ? Lista.find(params[:id]) : Lista.new(lista_params)
  end
end
