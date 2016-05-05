class RepositoryManager::FolderRelation < ActiveRecord::Base
  self.table_name = :rm_folder_relations

  belongs_to :folderable, polymorphic: true
  belongs_to :rm_repo_item, class_name: 'RepositoryManager::RepoItem'

  # validates :folderable, :rm_repo_item, presence: true

  enum role: [
    # Specific account, investment ownership, project, raze
    :own,

    # IMS system root:
    :organizations, :projects
  ]
end
