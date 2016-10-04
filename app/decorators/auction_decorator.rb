class AuctionDecorator < AssetDecorator
  delegate_all

  def condition_tag(condition)
    return "" if condition.to_s.empty?
    tag_name = @@condition_tags[condition.to_s.downcase]

    h.content_tag(:span,  tag_name.to_s.split('_')[1..-1].join(' ').capitalize, class: "tag #{tag_name}")
  end

  def index_condition_tag
    if condition.reject { |c| c.to_s.empty? }.size > 1
      condition_tag(conditions.first) + h.content_tag(:i, nil, class: 'fa fa-plus')
    else
      condition_tag(condition.first)
    end
  end

  def condition_header
    header = condition.reject { |c| c.to_s.empty? }.empty? ? "No Condition Avaiable" : "Acceptable Conditions"

    h.content_tag(:p, header)
  end
end
