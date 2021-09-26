class EmailBlacklistValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    if AdminBlacklistedEmail.is_banned?(value)
      # TODO: here
      record.errors[attribute] << (options[:message] || I18n.t('validators.email.banned'))
      return false
    else
      return true
    end
  end
end
