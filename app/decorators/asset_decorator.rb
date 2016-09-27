class AssetDecorator < Draper::Decorator
  delegate_all

  def condition_tag
    tag_name = {
      "recent" => :tag_new,
      "overhaul" => :tag_overhaul,
      "serviceable" => :tag_serviceable,
      "as_removed" => :tag_as_removed,
      "scrap" => :tag_scrap,
      "non_serviceable" => :tag_non_serviceable
    }[condition.to_s.downcase]

    h.content_tag(:span,  tag_name.to_s.split('_')[1..-1].join(' ').capitalize, class: "tag #{tag_name}")
  end

  def service_status_tag
    tag_name = {
      "in_service" => :tag_in_service,
      "off_service" => :tag_off_service
    }[service_status.to_s.downcase]

    h.content_tag(:span, tag_name.to_s.split('_')[1..-1].join(' ').capitalize, class: "tag #{tag_name}")
  end

  def self.to_s
    "#{super[0..-10]}"
  end
end
