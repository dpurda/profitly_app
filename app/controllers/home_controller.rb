class HomeController < ApplicationController
  def index
    redirect_to stocks_path if user_signed_in?
  end
end
