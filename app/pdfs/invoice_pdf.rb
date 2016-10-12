class InvoicePdf < Prawn::Document
include ActionView::Helpers::NumberHelper
  def initialize(product)
    super()
    @transaction = product
    font "Helvetica", size: 10
    header
    invoice_details
    vendor_details
    bill_to
    ship_to
    table_content
    fee_breakdown
    product_rows
    comment_section
    footer
  end

  def header
    #This inserts an image in the pdf file and sets the size of the image
    
    
    bounding_box([0, cursor], :width => 540, :height => 60) do
      image "#{Rails.root}/app/assets/images/bidaerologonavycaps.jpg", width: 178, height: 44.5, at: [0,cursor]
      bounding_box([400, cursor], :width => 540, :height => 100) do 
        text "\n INVOICE", size: 20, style: :bold, :color => "d3d3d3", align: :left, width: 100, fill_color: "FFFFFF"#, at: [450, cursor + 13]
      end
    end
  end

  def vendor_details
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor + 107.5

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], :width => 270, :height => 100) do
      move_down 10
      text "Vendor", size: 14, style: :bold
      stroke_horizontal_rule
      move_down 5
      text "#{@transaction.seller.name}"
      text "#{@transaction.seller.address}"
      text "#{@transaction.seller.city}, #{@transaction.seller.state} #{@transaction.seller.zip}"
    end
  end

  def invoice_details
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([270, y_position], :width => 270, :height => 110) do
      move_down 10
      text "Summary", size: 16, style: :bold
      stroke_horizontal_rule
      move_down 5
      text "Order ##{@transaction.order_id}", size: 10
      text "Invoice ##{@transaction.invoice_num}", size: 10
      text "P.O. ##{@transaction.po_num}", size: 10
      text "Date of Origination: #{@transaction.created_at.strftime("%Y-%m-%d")}", size: 10
      text "Terms: N/A", size: 10
      text "Required Arrival Date: #{@transaction.auction.required_date}", size: 10
    end
  end

  def bill_to
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position], :width => 270, :height => 100) do
      move_down 20
      text "Bill To", size: 14, style: :bold
      stroke_horizontal_rule
      move_down 5
      text "#{@transaction.buyer.name}"
      text "#{@transaction.buyer.address}"
      text "#{@transaction.buyer.city}, #{@transaction.buyer.state} #{@transaction.buyer.zip}"
    end
  end

  def ship_to
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor + 100

    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([270, y_position], :width => 270, :height => 80) do
      move_down 20
      text "Ship To", size: 14, style: :bold
      stroke_horizontal_rule
      move_down 5

      text "Destination Shop"
      text "#{@transaction.auction.destination_address}"
      text "#{@transaction.auction.destination_city}, #{@transaction.auction.destination_state} #{@transaction.auction.destination_zip}"
    end
  end

  def table_content
    move_down 10
    table product_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['FFFFFF', 'DDDDDD']
      style(row(0), :background_color => '283761', :text_color => "FFFFFF")
      self.column_widths = [100, 240, 200]
      self.cell_style = { :border_color => "D3D3D3" }
    end
  end

  def product_rows
    array = [['#', 'Name', 'Price']] +
      # @transaction.map do |product|
      [[@transaction.order_id, @transaction.auction.part_num, number_to_currency(@transaction.part_price)]]
    # end
    if array.count < 12
      array + [[" ", " ", " "]] * (12 - array.count)
    end
  end

  def fee_breakdown
    table fee_rows do
      self.row_colors = ['FFFFFF']
      self.column_widths = [340, 110, 90]
      self.cell_style = { border_color: ["d3d3d3","FFFFFF"] }
      style(row(0..4), :size => 10)
      self.column(0).border_color = "FFFFFF"
      self.row(0).border_color = ["d3d3d3","FFFFFF","FFFFFF","FFFFFF"]
    end
  end

  def comment_section
    y_position = cursor - 10
    bounding_box([0, y_position], :width => 540, :height => 75) do
      text "**comments"
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

  def fee_rows
    array = [["","Subtotal", number_to_currency(@transaction.part_price)]] + [["","Shipping", number_to_currency(@transaction.final_shipping_cost)]] + [["","Tax (#{@transaction.tax_rate}%)", number_to_currency(@transaction.tax)]] + [["","Service Fee", number_to_currency(@transaction.total_fee)]] + [["","Total Amount", number_to_currency(@transaction.total_amount)]]    
  end
end

