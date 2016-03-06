Hanami::Model.migration do
  change do
    create_table :tags do
      primary_key :id

      column :name,    String,  null: false,  unique: true, size: 255
      column :slug,    String,  null: true,   unique: true

      check { length(name) > 0 }
    end

    create_table :taggings do
      primary_key :id

      column :taggable_type, String,  null: false, size: 255
      column :taggable_id, Integer, null: false
      column :created_at, DateTime

      foreign_key(:tag_id, :tags)
      index [:tag_id, :taggable_type, :taggable_id], :unique => true

      check { length(taggable_type) > 0 }
    end
  end
end
