class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  private
  def current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def reject_user
    redirect_to root_path, alert: 'Вам сюда низя!'
  end

  def find_hashtag(string)
    hashtag_regexp = /#[[:word:]-]+/
    hashtags = string.scan(hashtag_regexp)
  end
end
