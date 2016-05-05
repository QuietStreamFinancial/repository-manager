class AddDocusignFlagToRmRepoItems < ActiveRecord::Migration
  def change
    add_column :rm_repo_items, :docusign_flag, :boolean, default: false
  end
end
