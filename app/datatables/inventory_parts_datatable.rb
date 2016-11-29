class InventoryPartsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: InventoryPart.count,
      iTotalDisplayRecords: inventory_parts.total_entries,
      data: data
    }
  end

private

  def data
    inventory_parts.map do |part|
      [
        link_to(part.name, part),
        h(part.condition.decorate),
        h(part.created_at.strftime("%B %e, %Y")),
        part.manufacturer
      ]
    end
  end

  def inventory_parts
    @inventory_parts ||= fetch_inventory_parts
  end

  def fetch_inventory_parts
    inventory_parts = InventoryPart.order("#{sort_column} #{sort_direction}")
    inventory_parts = inventory_parts.page(page).per_page(per_page)
    if params[:sSearch].present?
      inventory_parts = inventory_parts.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    inventory_parts
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end