class AuctionDecorator < AssetDecorator
  delegate_all

  def condition_tag(condition)
    return "" if condition.to_s.empty?
    tag_name = @@condition_tags[condition.to_s.downcase]

    h.content_tag(:span,  tag_name.to_s.split('_')[1..-1].join(' ').capitalize, class: "tag #{tag_name}")

  end

  def abbreviated_condition_tag(condition)
    # return "" if condition.to_s.empty?
    # tag_name = @@abbreviated_condition_tags[condition.to_s.downcase]  
    # h.content_tag(:span,  tag_name.to_s.split('_')[1..-1].join(' ').upcase, class: "tag #{tag_name}")
    # h.content_tag(:span, AuctionDecorator.rename(self.object, conditions), class: "tag #{tag_name}")
  end

  def abbreviated_conditions
    conditions.map do |condition|
      case condition
      when :overhaul
        "OH"
      when :recent
        "NE"
      when :serviceable
        "SV"
      when :as_removed
        "AR"
      when :scrap
        "SC"
      when :non_serviceable
        "NSV"
      end
    end
  end

  def abbreviated_index_tags
    if abbreviated_conditions.count > 1
      abbreviated_conditions.reject(&:blank?).map do |abbrev_cond|
        h.content_tag(:span, abbrev_cond, class: "tag tag_#{abbrev_cond.downcase}")
      end.to_sentence.html_safe
    else
      "All Conditions"
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
