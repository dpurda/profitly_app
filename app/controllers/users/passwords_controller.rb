class Users::PasswordsController < ApplicationController
  before_action :authenticate_user!

  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in(current_user)
      render turbo_stream: turbo_stream.update('change_password_frame',
        partial: 'users/passwords/success')
    else
      render turbo_stream: turbo_stream.update('change_password_frame',
        partial: 'users/passwords/form', locals: { user: current_user })
    end
  end

  private

  def password_params
    params.expect(user: [ :current_password, :password, :password_confirmation ])
  end
end
