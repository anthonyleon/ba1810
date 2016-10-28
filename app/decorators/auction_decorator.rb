class AuctionDecorator < AssetDecorator
  delegate_all

  def condition_tag(condition)
    return "" if condition.to_s.empty?
    tag_name = @@condition_tags[condition.to_s.downcase]

    h.content_tag(:span,  tag_name.to_s.split('_')[1..-1].join(' ').capitalize, class: "tag #{tag_name}")

  end

  def abbreviated_condition_tag(condition)
    return "" if condition.to_s.empty?
    tag_name = @@abbreviated_condition_tags[condition.to_s.downcase]  
    h.content_tag(:span,  tag_name.to_s.split('_')[1..-1].join(' ').upcase, class: "tag #{tag_name}")
  end

  def abbreviated_index_tags
    if condition.reject { |c| c.to_s.empty? }.size > 1

      collection = abbreviated_condition_tag(conditions.first)
      count = 1
      condition.each do |c|
        collection += abbreviated_condition_tag(conditions[count])
        count += 1
      end
      collection 
    else
      abbreviated_condition_tag(condition.first)
    end
  end

  def index_condition_tag
    if condition.reject { |c| c.to_s.empty? }.size > 1

      collection = condition_tag(conditions.first)
      count = 1
      condition.each do |c|
        collection += condition_tag(conditions[count])
        count += 1
      end
      collection 
    else
      condition_tag(condition.first)
    end
  end

  def condition_header
    header = condition.reject { |c| c.to_s.empty? }.empty? ? "All Conditions" : "Acceptable Conditions"

    h.content_tag(:p, header)
  end
end
