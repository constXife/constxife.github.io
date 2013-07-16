class AddSlugToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.string :slug
    end

    add_index :posts, :slug, unique: true
  end
end
