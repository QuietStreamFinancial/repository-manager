class FolderRelation < ActiveRecord::Base
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
