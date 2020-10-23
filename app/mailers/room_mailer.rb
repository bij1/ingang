class RoomMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.room_mailer.invite.subject
  #
  def invite
    @user = params[:user]
    @url = params[:url]
    mail(to: "#{ @user.name } <#{ @user.email }>", subject: 'Toegang ledenvergadering BIJ1 24 oktober')
  end
end
