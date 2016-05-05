class AddDisplayPromptsToRmRepoItems < ActiveRecord::Migration
  def change
    add_column :rm_repo_items, :display_prompts, :jsonb, null: false, default: '{}'
    add_index :rm_repo_items, :display_prompts, using: :gin
  end
end
