class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    
    mail to: user.email, subject: t("user_mail.account_activation")
  end

  def password_reset
    @greeting = t("user_mail.greeting")

    mail to: "to@example.org"
  end
end
