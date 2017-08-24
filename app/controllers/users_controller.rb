class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per Settings.paginate_default
  end
end
