atom_feed :language => 'ru-RU' do |feed|
  feed.title('Лента новостей')
  feed.updated(@posts.first.created_at)
  feed.author do |author|
    author.name('Тыщ constXife Кьятлоттьяви')
    author.email('zombie.with.hair@gmail.com')
  end
  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.preview, :type => 'html')
    end
  end
end