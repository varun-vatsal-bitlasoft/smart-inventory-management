class InventoryCheckJob < ApplicationJob
  queue_as :default

  def perform
    zero_size_items = Inventory.where(size: 0)

    zero_size_items.each do |item|
      NotificationMailer.low_inventory_warning(item).deliver_now
      item.destroy
    end
  end
end
