# frozen_string_literal: true

class PlantillasReflex < ApplicationReflex
  delegate :plantilla_params, to: :controller

  def actualizar_campos
    morph :nothing
    reutilizable = ActiveRecord::Type::Boolean.new.cast(plantilla_params[:reutilizable])
    cable_ready.set_attribute(selector: "#form-plantilla", name: "disabled", value: true).broadcast if reutilizable
    cable_ready.remove_attribute(selector: "#form-plantilla", name: "disabled").broadcast unless reutilizable
  end
end
