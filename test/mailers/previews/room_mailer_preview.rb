# Preview all emails at http://localhost:3000/rails/mailers/room_mailer
class RoomMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/room_mailer/invite
  def invite
    RoomMailer.invite
  end

end
