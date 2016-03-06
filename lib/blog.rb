require 'hanami/model'
Dir["#{ __dir__ }/blog/**/*.rb"].each { |file| require_relative file }

Hanami::Model.configure do
  ##
  # Database adapter
  #
  # Available options:
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/blog_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/blog_development.sqlite3'
  #    adapter type: :sql, uri: 'postgres://localhost/blog_development'
  #    adapter type: :sql, uri: 'mysql://localhost/blog_development'
  #
  adapter type: :sql, uri: ENV['BLOG_DATABASE_URL']

  ##
  # Migrations
  #
  migrations 'db/migrations'
  schema     'db/schema.sql'

  ##
  # Database mapping
  #
  # Intended for specifying application wide mappings.
  #
  # You can specify mapping file to load with:
  #
  # mapping "#{__dir__}/config/mapping"
  #
  # Alternatively, you can use a block syntax like the following:
  #
  mapping do
    collection :posts do
      entity     Post
      repository PostRepository

      attribute :id,      Integer
      attribute :title,   String
      attribute :preview, String
      attribute :content, String
      attribute :slug,    String
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
    end
  end
end.load!
