class AdminMailer < ApplicationMailer
	skip_before_action :requre_logged_in
	# Subject can be set in your I18n file at config/locales/en.yml
	# with the following lookup:
	#
	#   en.company_mailer.registration_confirm.subject
	#
	def yee
		mail to: 'gmartinez@bid.aero', subject: 'YEE GABO IT WORKED'
	end

	def resale_uploaded(company, document)
		@company = company
		@document = document
		mail to: 'support@bid.aero', subject: "Somebudy uploaded a resale certificate."
	end

	def new_register(company)
		@company = company

		mail to: 'support@bid.aero', subject: "New Client Registration"
	end

	def new_auction(auction)
		@auction = auction
		@company = auction.company
		@auction_id = auction.id
		@invites = Hash[auction.invites.map(&:company).map(&:name).zip(auction.invites.map(&:company).map(&:email))]
		mail to: 'support@bid.aero', subject: "#{@company.name.upcase} JUST CREATED AN AUCTION"
	end

	def new_bid(bid)
		@bid = bid
		@company = bid.company
		@bid_id = bid.id
		@auction = bid.auction

		mail to: "support@bid.aero", subject: "#{@company.name.upcase} JUST CREATED A BID"
	end

	def new_lead(contact, company, phone, email, message, subject)
		@name = contact
		@company = company
		@phone = phone
		@email = email
		@message = message

		mail to: 'support@bid.aero', subject: "Bid Aero 2.0"

	end


	def no_part_match(auction)
		@auction = auction
		@company = auction.company

		mail to: 'support@bid.aero', subject:  "#{@company.name.upcase} MADE AN AUCTION W NO MATCH TO PARTS_DB"
	end

	def no_matches_for_auction(company, auction)
		#company who created the auction
		@company = company
		@auction = auction

		mail to: 'support@bid.aero', subject: "No Matches To A New Auction"
	end

	def new_contact(company, phone, email, message)
		@company = company
		@phone = phone
		@email = email
		@message = message

		mail to: 'support@bid.aero', subject: "Someone filled out the contact form"
	end

	def new_contact_autoreply(company, phone, email, message)
		@company = company
		@phone = phone
		@email = email
		@message = message

		mail to: @email , subject: "Thanks for reaching out, Bid Aero is here to help!"
	end

end
