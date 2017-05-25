buy = ["A new bid was placed in your auction!",
 "A new quote was placed in your RFQ!",
 "You have won an RFQ! Please finalize tax and shipping costs, and input your invoice number.",
 "A new quote was placed in your auction!"]

sell = ["You have a new opportunity to sell!",
 "A quote has been placed on an RFQ you are participating in!",
 "A bid has been placed on an auction you are participating in!",
 "A quote has been placed on an auction you are participating in!"]

n = ["You have won an auction! Please finalize tax and shipping costs, and input your invoice number.", "Seller has finalized costs. Please send funds to escrow."]

buy.each { |b| Notification.where(message: b).each { |n| n.update(category: :buy) } }

sell.each { |b| Notification.where(message: b).each { |n| n.update(category: :sell) } }

n.each { |b| Notification.where(message: b).each { |n| n.update(category: :action_required) } }