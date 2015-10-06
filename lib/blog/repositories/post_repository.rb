class PostRepository
  include Lotus::Repository

  class << self
    def tag_list(id)
      sql = <<-SQL
        select tags.name from posts
        inner join taggings
        on (posts.id = taggings.taggable_id)
        and (taggings.taggable_type = 'Post')
        inner join tags
        on (taggings.tag_id = tags.id)
        where posts.id = #{id}
      SQL
      fetch(sql).collect{|r| r[:name]}
    end

    def get_list(tag_name: '', limit: 8)
      if tag_name && !tag_name.empty?
        sql = <<-SQL
          SELECT posts.*, tags.name as tag_name FROM posts
          INNER JOIN taggings
          ON (posts.id = taggings.taggable_id)
          AND (taggings.taggable_type = 'Post')
          INNER JOIN tags
          ON (taggings.tag_id = tags.id)
          WHERE tags.name = $$#{tag_name}$$
          ORDER BY posts.created_at DESC
          LIMIT #{limit}
        SQL
      else
        sql = <<-SQL
          SELECT * FROM posts
          ORDER BY created_at DESC
          LIMIT #{limit}
        SQL
      end
      fetch(sql).map {|r| Post.new(r)}
    end

    def find_by_slug(slug)
      query.where(slug: slug).first
    end

    def add_tag(id, tag_name)
      tag = retrieve_or_create_tag(tag_name)

      if tag && !tag_exist?(id, tag[:id])
        sql = <<-SQL
          INSERT INTO taggings (taggable_type, taggable_id, tag_id, created_at)
          VALUES ('Post', #{id}, #{tag[:id]}, NULL)
        SQL
        execute(sql)
      end
    end

    def tag_exist?(id, tag_id)
      sql = <<-SQL
        SELECT id
        FROM taggings
        WHERE taggable_type = 'Post' AND taggable_id = #{id} AND tag_id = #{tag_id}
        LIMIT 1
      SQL
      fetch(sql).count > 0
    end

    def tags_reset!
      sql = <<-SQL
        TRUNCATE tags CASCADE;
      SQL
      execute(sql)
    end

    def retrieve_or_create_tag(tag_name)
      sql = <<-SQL
        SELECT id FROM tags
        WHERE name = '#{tag_name}'
      SQL

      result = fetch(sql)

      if result.empty?
        sql = <<-SQL
          INSERT INTO tags (name)
          VALUES ('#{tag_name}')
          RETURNING id;
        SQL
        result = fetch(sql)
      end

      result.first
    end
  end
end
