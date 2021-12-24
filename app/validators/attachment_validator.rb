class AttachmentValidator < ActiveModel::EachValidator
  include ActiveSupport::NumberHelper # ①

  def validate_each(record, attribute, value)
    return if value.blank? || !value.attached?

    has_error = false

    if options[:maximum]
      if value.is_a?(ActiveStorage::Attached::Many) #③
        # 画像が複数枚投稿された場合
        value.each do |v|
          unless validate_maximum(record, attribute, v)
            has_error = true
            break
          end
        end
      else
        # 画像が1枚投稿された場合
        has_error = true unless validate_maximum(record, attribute, value)
      end
    end

    record.send(attribute).purge if options[:purge] && has_error
  end

  private

  def validate_maximum(record, attribute, value)
    if value.byte_size > options[:maximum]#②
      record.errors[attribute] << (options[:message] || "は#{number_to_human_size(options[:maximum])}以下にしてください")
      false
    else
      true
    end
  end

end