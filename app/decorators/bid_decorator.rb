class BidDecorator < Draper::Decorator
  delegate_all
  decorates_association :inventory_part
end
