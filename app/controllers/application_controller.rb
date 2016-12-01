class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate           # ログイン認証
  before_action :reset_session_expires  # セッション有効期限延長

  private

  # ログイン認証
  def authenticate
    unless signed_in?
      session[:request_url] = request.url

      redirect_to :root and return
    end
  end

  # セッション期限延長
  def reset_session_expires
    request.session_options[:expire_after] = 2.weeks
  end

  # ログインユーザ
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  # ログイン／ユーザ登録済みチェック
  def signed_in?
    User.where(id: session[:user_id]).exists?
  end
  helper_method :signed_in?
end
