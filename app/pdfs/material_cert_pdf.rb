class MaterialCertPdf < Prawn::Document

  def initialize(part)
    super()
    @transaction = part
    font "Helvetica", size: 10
    table_one
    table_two
    table_three
    table_four
    table_five
    box
    footer
  end

  def table_one
    move_down 10
    table title do
      self.column_widths = [540]
      self.cell_style = { height: 35, :border_color => "D3D3D3" }
      style(row(0), size: 22, align: :center )
    end
  end

  def title
    array = [['PART OR MATERIAL CERTIFICATION FORM']]
  end

  def table_two
    table reference do
      self.column_widths = [270, 270]
      self.cell_style = { height: 80, border_color: 'd3d3d3' }
    end
  end

  def reference
    [["SELLER: #{@transaction.seller.name} \n#{@transaction.seller.address} \n#{@transaction.seller.city}, #{@transaction.seller.state} #{@transaction.seller.zip} \n\n e-mail: #{@transaction.seller.email}", "CUSTOMER PO ##{@transaction.po_num} \nCUSTOMER INVOICE ##{@transaction.invoice_num} \nBID AERO ORDER ##{@transaction.order_id}"]]
  end

  def table_three
    table breakdown do
      self.column_widths = [40, 140, 205, 30, 75, 50]
      self.cell_style = { height: 40, border_color: 'd3d3d3' }
      style(row(1), height: 165)
    end
  end

  def breakdown
    [["ITEM", "DESCRIPTION", "MANUFACTURER / PART NUMBER", "QTY", "SERIAL", "STATUS"]] +
    [["1", "#{@transaction.bid.inventory_part.description}", "#{@transaction.auction.part_num}", "1", "#{@transaction.bid.inventory_part.serial_num}", "#{@transaction.bid.inventory_part.condition}"]]
  end

  def table_four
    table lower_portion do
      self.column_widths = [270, 270]
      self.cell_style = { height: 40, border_color: 'd3d3d3' }
      style(row(1), height: 165)
    end
  end

  def lower_portion
      [["TRACEABLE TO: #{@transaction.seller.name}", "LAST CERTIFIED AGENCY:"], ["NEW PARTS / MATERIAL VERIFICATION: \n\n THE FOLLOWING SIGNATURE ATTESTS THAT THE PART(S) OR MATERIAL(S) IDENTIFIED ABOVE WAS (WERE) MANUFACTURED BY A FAA PRODUCTION APPROVAL HOLDER (PAH), OR TO AN INDUSTRY COMMERCIAL STANDARD.", " USED, REPAIRED OR OVERHAUL PARTS VERIFICATION:\n\n THE FOLLOWING SIGNATURE ATTEST THAT THE DOCUMENTATION SPECIFIED ABOVE ATTACHED IS ACCURATE WITH REGARD TO THE ITEM(S) DESCRIBED"], ["SIGNATURE:", "SIGNATURE:"]]
  end

  def table_five
    table last_bit do
      self.column_widths = [135, 135, 135, 135]
      self.cell_style = { height: 40, border_color: 'd3d3d3' }
    end
  end

  def last_bit
    [["NAME:", "DATE:", "NAME:", "DATE:"]]
  end

  def box
    y_position = cursor
    bounding_box([0, y_position], :width => 540, :height => 50) do
      stroke_color 'D3D3d3'
      stroke_bounds
      text " "
      text "To the best of our knowledge, this part has not been involved in a major incident and has not been subject to severe stress of heat (as in major engine failure, accident or fire). The part was not obtained from U.S. Government or military sources."
    end
  end

  def footer
    y_position = cursor - 10
    bounding_box([0, y_position], :width => 540, :height => 75) do
      fill_color "D3D3e4"
      stroke_color "d3d3d3"
      stroke_horizontal_rule
      move_down 10
      text "     Bid Aero, Inc.     |     www.bid.aero     |     305.726.8867     |     support@bid.aero     ", align: :center
    end
  end

end

