class UnmatchedAuctionsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:draw].to_i,
      iTotalRecords: Auction.where(matched: false).count,
      iTotalDisplayRecords: auctions.count,
      aaData: data.as_json
    }
  end

private
  
  def yolo
  	binding.pry
  end

  def data
    auctions.map do |auct|
      [
      	auct.company.name,
        link_to(auct.part_num, auct),
        (AssetDecorator.rename(auct, auct.condition)),
        auct.required_date || "N/A",
        auct.target_price || "N/A",
        auct.created_at.in_time_zone('Eastern Time (US & Canada)').strftime("%m/%d/%y")
      ]
    end
  end

  def auctions
    @auctions ||= fetch_auctions
  end

  def fetch_auctions
    auctions = Auction.where(matched: false).order("#{sort_column} #{sort_direction}")
    auctions = auctions.page(page).per_page(per_page)
    if params[:search].present?
      auctions = auctions.where("part_num LIKE ?", "%#{params[:search][:value].upcase}%")
    end
    auctions
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[id part_num condition required_date target_price created_at]
    columns[params[:order]["0"][:column].to_i]
  end

  def sort_direction
    params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end
end