class ContactMailer < ApplicationMailer
  def contact_us(contact)
    @contact = contact
    mail(
      from: @contact.email.presence || "noreply@wordcraze.com",
      to: ENV.fetch("CONTACT_EMAIL", "scott@scoran.com"),
      subject: "Someone sent feedback on Wordcraze"
    )
  end
end
