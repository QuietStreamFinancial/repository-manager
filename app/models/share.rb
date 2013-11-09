class Share < ActiveRecord::Base
  attr_accessible :can_read, :can_create, :can_update, :can_delete, :can_share if RepositoryManager.protected_attributes?


  has_many :shares_items, dependent: :destroy
  belongs_to :owner, :polymorphic => true
  belongs_to :repository

  #scope :recipient, lambda { |recipient|
  #  joins(:receipts).where('receipts.receiver_id' => recipient.id,'receipts.receiver_type' => recipient.class.base_class.to_s)
  #}
  scope :items, lambda { |item|
    joins(:shares_items).where('shares_items.item_id' => item.id,'shares_items.item_type' => item.class.base_class.to_s)
  }

  # Return the authorisations of the share for the item
  def get_authorisations(item)
    # If the item is the owner, he can do what he want !
    if self.owner == item
      return true
    elsif i = self.shares_items.where(item_id: item.id, item_type: item.class.base_class.to_s).take
      return {can_add: i.can_add, can_remove: i.can_remove}
    else
      return false
    end
  end

  # Add items to the share
  def addItems(items, share_permissions=nil)
    if items.kind_of?(Array)
      # Add each item to this share
      items.each do |i|
        shareItem = SharesItem.new(share_permissions)
        shareItem.item = i
        # Add the shares items in the share
        self.shares_items << shareItem
      end
    else
      shareItem = SharesItem.new(share_permissions)
      shareItem.item = items
      # Add the shares items in the share
      self.shares_items << shareItem
    end
  end

  # Remove items to the share
  def removeItems(items)
    if items.kind_of?(Array)
      # Add each item to this share
      items.each do |item|
        self.shares_items.where(item_id: item.id, item_type: item.class.base_class.to_s).take.destroy
      end
    else
      self.shares_items.where(item_id: items.id, item_type: items.class.base_class.to_s).take.destroy
    end
  end

end
