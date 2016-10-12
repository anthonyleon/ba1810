namespace :condition do
  desc "Update record data from tables with condition column, to integers"

  task update: :environment do
    puts "This will update all the record data from tables with a condition column, to integers"

    %w[new overhaul as_removed serviceable scrap].each_with_index do |c, index|
      puts "Updating records with #{c} condition"
      [Auction, InventoryPart, Engine].each do |t|
        c = 'OH' if c == 'overhaul' && t == InventoryPart
        t.where("condition ilike '%#{c}%'").each do |i|
          puts "Updating record #{i} to condition #{index}"
          i.update(condition: index)
        end
      end
    end
  end

end
