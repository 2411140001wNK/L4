class TopController < ApplicationController
  def main
    if session[:login_uid].nil?
      render :login
    else
      render :main
    end
  end

  def login
    uid = params[:uid]
    password = params[:pass]

    if uid == "kindai" && password == "sanriko"
      session[:login_uid] = uid
      redirect_to top_main_path
    else
      render :error
    end
  end
end
