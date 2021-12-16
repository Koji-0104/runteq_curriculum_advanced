class SearchArticlesForm
  include ActiveModel::Model #ActiveRecodeと同じようにコードがかけるようになる。
  include ActiveModel::Attributes

#ActiveModel::Attributesで属性を定義する。
  attribute :category_id, :integer
  attribute :author_id, :integer
  attribute :tag_id, :integer
  attribute :title, :string
  attribute :body, :string

  def search
    relation = Article.distinct

    relation = relation.by_category(category_id) if category_id.present?
    title_words.each do |word|
      relation = relation.title_contain(word)
    end
    relation = relation.by_author(author_id) if author_id.present?
    relation = relation.by_tag(tag_id) if tag_id.present?
    body_words.each do |word|
      relation = relation.body_contain(word)
    end

    relation
  end

  private

  def title_words
    title.present? ? title.split(nil) : []
  end

  def body_words
    body.present? ? body.split(nil) : []
  end
end
