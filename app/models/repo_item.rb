class RepoItem < ActiveRecord::Base
  attr_accessible :type if RepositoryManager.protected_attributes?


  has_ancestry

  # Associate with the User Class
  belongs_to :owner, :polymorphic => true
  has_many :sharings, :dependent => :destroy
  #has_many :members, through: :sharings

  if Rails::VERSION::MAJOR == 4
    scope :files, -> { where type: 'RepoFile' }
    scope :folders, -> { where type: 'RepoFolder' }
  else
    # Rails 3 does it this way
    scope :files, where(type: 'RepoFile')
    scope :folders, where(type: 'RepoFolder')
  end

  def copy(target_folder)
    #new_file = self.dup
    #new_file.folder = target_folder
    #new_file.save!
    #
    #path = "#{Rails.root}/uploads/#{Rails.env}/#{new_file.id}/original"
    #FileUtils.mkdir_p path
    #FileUtils.cp_r self.attachment.path, "#{path}/#{new_file.id}"
    #
    #new_file
  end

  # Move itself into the target_folder
  def move!(target_folder)
    if target_folder.type == 'RepoFolder'
      self.update_attribute :parent, target_folder
    else
      raise RepositoryManager::RepositoryManagerException.new("move failed. target '#{name}' can't be a file")
    end
  end

  def move(target_folder)
    begin
      move!(target_folder)
    rescue RepositoryManager::RepositoryManagerException
      false
    end
  end

  # Returns true if it exist a sharing in the ancestors of descendant_ids of the repo_item (without itself)
  def has_nested_sharing?
    # An array with the ids of all ancestors and descendants
    ancestor_and_descendant_ids = []
    ancestor_and_descendant_ids << self.descendant_ids if !self.descendant_ids.empty?
    ancestor_and_descendant_ids << self.ancestor_ids if !self.ancestor_ids.empty?

    # If it is a sharing, it returns true
    if Sharing.where(repo_item_id: ancestor_and_descendant_ids).count > 0
      true
    else
      false
    end
  end

end
