class UsersController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :move_to_signed_in
    
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(current_user.id)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def is_matching_login_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  def move_to_signed_in
    unless user_signed_in?
    #サインインしていないユーザーはログインページが表示される
    redirect_to  '/users/sign_in'
    end
  end
end
