namespace :status_task do
    desc '公開待ちの記事の中で、公開日時が過去になったものはステータスを公開に変える'
      task update_status_task: :environment do
        Article.publish_wait.past_published.find_each(&:published!)
      end
  end