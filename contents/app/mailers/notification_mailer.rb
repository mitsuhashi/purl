class NotificationMailer < ApplicationMailer
  default from: "admin@purl"

  def send_reg_user_to_admin(fullname, username, email, affiliation, justification)
    admins = User.where(admin_flag: true)
    @to = ''
    i = 0
    for admin in admins do
      if i == 0
        @to = admin.email
      else
        @to = @to + "," + admin.email
      end
      i = i + 1
    end

    @fullname = fullname
    @userid = username
    @email = email
    @affiliation = affiliation
    @justification = justification

    mail(
      subject: "ユーザーからUser IDの申請がありました (" + @fullname + ")",
      to: @to
    ) do |format|
      format.text
    end
  end
end
