class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(Setting.system_from_email, Setting.system_from_name)
  # layout 'mailer'
  layout 'bootstrap-mailer'

  # Word Past Tense
  def past_tense x
    x.sub(/([^aeiouy])y$/,'\1i').sub(/([^aeiouy][aeiou])([^aeiouy])$/,'\1\2\2').sub(/e$/,'')+'ed'
  end

end
