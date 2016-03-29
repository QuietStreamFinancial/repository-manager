class AddDisplayFlagsToRmRepoItems < ActiveRecord::Migration
  def change
    add_column :rm_repo_items, :display_flags, :jsonb, null: false, default: '{}'
  end
end
