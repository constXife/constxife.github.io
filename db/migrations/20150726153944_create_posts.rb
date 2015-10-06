Lotus::Model.migration do
  change do
    create_table :posts do
      primary_key :id

      column :title,    String,  null: false, unique: true, size: 255
      column :preview,  String,  null: true, text: true
      column :content,  String,  null: false, text: true, default: ''
      column :slug,     String,  null: true, unique: true

      column :created_at, DateTime
      column :updated_at, DateTime

      check { length(title) > 0 }
      check { length(content) > 0 }
    end
  end
end
