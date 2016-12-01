class InventoryPartsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view, company)
    @view = view
    @company = company
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: @company.inventory_parts.count,
      iTotalDisplayRecords: @company.inventory_parts.count,
      data: data
    }

  end

private

  def data
    inventory_parts.map do |part|
      [
        link_to(part.part_num, part),
        (part.condition),
        (part.created_at.strftime("%B %e, %Y")),
        part.manufacturer
      ]
    end
  end

  def inventory_parts
    @inventory_parts ||= fetch_inventory_parts
  end

  def fetch_inventory_parts
    inventory_parts = @company.inventory_parts.order("#{sort_column} #{sort_direction}")
    inventory_parts = inventory_parts.page(page).per_page(per_page)
    if params[:sSearch].present?
      inventory_parts = inventory_parts.where("part_num like :search or category like :search", search: "%#{params[:sSearch]}%")
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
    columns = %w[part_num category released_on price]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end