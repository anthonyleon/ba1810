class CurrentOpportunitiesDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view, company)
    @view = view
    @company = company
  end

  def as_json(options = {})
    {
      sEcho: params[:draw].to_i,
      iTotalRecords: Auction.get_sales_opportunities(@company).count,
      iTotalDisplayRecords: current_opportunities.count,
      aaData: data.as_json
    }
  end

private
  
  def data
    current_opportunities.map do |auction|
      [
        link_to(auction.part_num, auction),
        auction.auction_part.description,
        # auction.condition[0].blank? ? "All Conditions" : auction.abbreviated_index_tags,
        "All Conditions",
        auction.created_at.strftime("%m/%d/%Y"),
        ((Time.zone.now - auction.created_at) / 1.day).to_i,
        auction.bids.count,
      	auction.bids ? number_to_currency(auction.bids.minimum(:part_price)) : "N/A"
      ]
    end
  end

  def current_opportunities
    @current_opportunities ||= fetch_current_opportunities
  end

  def fetch_current_opportunities
    current_opportunities = Auction.get_sales_opportunities(@company).order("#{sort_column} #{sort_direction}")
    current_opportunities = current_opportunities.page(page).per_page(per_page)
    if params[:search].present?
      current_opportunities = current_opportunities.where("part_num LIKE ?", "%#{params[:search][:value]}%")
    end
    current_opportunities
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[part_num description conditions created_at elapsed_time bids lowest_bid]
    columns[params[:order]["0"][:column].to_i]
  end

  def sort_direction
    params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end
end