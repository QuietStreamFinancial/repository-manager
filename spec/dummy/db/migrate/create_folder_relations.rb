class CreateFolderRelations < ActiveRecord::Migration
  def change
    create_table :folder_relations do |t|
      t.belongs_to :folderable, polymorphic: true, index: true
      t.belongs_to :rm_repo_item, index: true, foreign_key: true
      t.integer :role
    end
  end
end
