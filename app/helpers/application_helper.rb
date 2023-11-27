module ApplicationHelper
  def localize(object, **options)
    super(object, **options) if object.present?
  end
end
