namespace :state_update do
    desc "記事のstateの更新"
    task update: :environment do
      @articles = Article.where(state: "publish_wait")
      @articles.each do |article|
        if article.published_at < Time.current
          article.update( state: "published" )
        end
      end
    end
  end