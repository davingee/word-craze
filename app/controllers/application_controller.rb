class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :user_signed_in?, :admin?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  def admin?
    current_user&.admin?
  end

  def require_login
    unless user_signed_in?
      flash[:alert] = "Please sign in to continue."
      redirect_to new_session_path
    end
  end

  def random_word
    @random_word ||= Word.random_playable
  end

  def get_associations(word)
    @get_associations ||= begin
      scrubbed = Association
        .joins("JOIN words AS w ON w.id = associations.association_id")
        .where(word_id: word.id, scrubbed: true, user_word: false)
        .select("associations.id, associations.association_id, associations.count, w.name AS word_name")
        .order(Arel.sql("RANDOM()"))
        .limit(10)

      user_made = Association
        .joins("JOIN words AS w ON w.id = associations.association_id")
        .where(word_id: word.id, user_word: true)
        .select("associations.id, associations.association_id, associations.count, w.name AS word_name")
        .order(Arel.sql("RANDOM()"))
        .limit(15)

      (scrubbed.to_a + user_made.to_a).uniq { |a| a.association_id }
    end
  end
end
