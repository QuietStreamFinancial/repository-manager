class AddDisplayFlagsToRmRepoItems < ActiveRecord::Migration
  def change
    add_column :rm_repo_items, :display_flags, :jsonb, null: false, default: '{}'
    add_index :rm_repo_items, :display_flags, using: :gin
  end
end
