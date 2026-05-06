class RegistrationsController < ApplicationController
  def new
  end

  def challenge
    user_handle = SecureRandom.random_bytes(16)
    encoded_handle = Base64.urlsafe_encode64(user_handle, padding: false)

    options = WebAuthn::Credential.options_for_create(
      user: {
        id: encoded_handle,
        name: params[:username],
        display_name: params[:username]
      },
      authenticator_selection: {
        resident_key: "required",
        user_verification: "required"
      }
    )

    session[:pending_registration] = {
      challenge: options.challenge,
      username: params[:username],
      email: params[:email],
      user_handle: encoded_handle
    }

    render json: options
  end

  def create
    pending = session[:pending_registration]
    return render json: { error: "No pending registration found." }, status: :unprocessable_entity unless pending

    credential = WebAuthn::Credential.from_create(params[:credential])
    credential.verify(pending["challenge"])

    user = User.create!(
      username: pending["username"],
      email: pending["email"],
      webauthn_id: pending["user_handle"]
    )
    user.webauthn_credentials.create!(
      external_id: credential.id,
      public_key: credential.public_key,
      sign_count: credential.sign_count
    )

    session.delete(:pending_registration)
    session[:user_id] = user.id

    render json: { redirect_url: root_path }
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue WebAuthn::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
