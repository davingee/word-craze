class SessionsController < ApplicationController
  def new
  end

  def challenge
    options = WebAuthn::Credential.options_for_get(user_verification: "required")
    session[:webauthn_challenge] = options.challenge
    render json: options
  end

  def create
    credential = WebAuthn::Credential.from_get(params[:credential])
    stored = WebauthnCredential.find_by!(external_id: credential.id)

    credential.verify(
      session[:webauthn_challenge],
      public_key: stored.public_key,
      sign_count: stored.sign_count
    )

    stored.update!(sign_count: credential.sign_count)
    session.delete(:webauthn_challenge)
    session[:user_id] = stored.user_id

    render json: { redirect_url: root_path }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Passkey not recognised." }, status: :unprocessable_entity
  rescue WebAuthn::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Signed out."
  end
end
