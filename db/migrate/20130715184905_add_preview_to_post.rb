class AddPreviewToPost < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.text :preview
    end
  end
end
