class InventoryPartsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view, company)
    @view = view
    @company = company
  end

  def as_json(options = {})
    {
      sEcho: params[:draw].to_i,
      iTotalRecords: @company.inventory_parts.count,
      iTotalDisplayRecords: inventory_parts.count,
      aaData: data.as_json
    }

  end

private

  def yolo
    binding.pry
  end
  
  def data

    inventory_parts.map do |part|
      [
        link_to(part.part_num, part),
        (part.description),
        (part.serial_num || "N/A"),
        (AssetDecorator.rename(part, part.condition)),
        ((part.manufacturer) || "N/A")
      ]

    end
    
  end

  def inventory_parts
    @inventory_parts ||= fetch_inventory_parts
  end

  def fetch_inventory_parts
    inventory_parts = @company.inventory_parts.order("#{sort_column} #{sort_direction}")
    inventory_parts = inventory_parts.page(page).per_page(per_page)
    if params[:search].present?
      inventory_parts = inventory_parts.where("part_num LIKE ?", "%#{params[:search][:value]}%")
    end
    inventory_parts
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  def sort_column
    columns = %w[part_num description serial_num condition manufacturer]
    columns[params[:order]["0"][:column].to_i]
  end

  def sort_direction
    params[:order]["0"][:dir] == "desc" ? "desc" : "asc"
  end
end