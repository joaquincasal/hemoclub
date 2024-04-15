# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'donacion', 'donaciones'
  inflect.irregular 'factor', 'factores'
  inflect.irregular 'exclusion', 'exclusiones'
  inflect.irregular 'lista', 'listas'
  inflect.irregular 'lista dinamica', 'listas dinamicas'
  inflect.irregular 'lista_dinamica', 'listas_dinamicas'
  inflect.irregular 'difusion', 'difusiones'
  inflect.irregular 'lista estatica', 'listas estaticas'
  inflect.irregular 'lista_estatica', 'listas_estaticas'
  inflect.irregular 'campania', 'campanias'
end
