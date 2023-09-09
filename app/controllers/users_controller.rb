class UsersController < ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :move_to_signed_in

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
  #  roomがcreateされた時に現在ログインしているユーザーと、
  # 「チャットへ」ボタンを押されたユーザーの両方をEntriesテーブルに記録する必要があるので、
  # whereメソッドを使いもう1人のユーザーを探している
  # whereメソッドは、テーブル内の条件に一致したレコードを取得することができる
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
            # Entriesテーブル内にあるroom_idが共通しているユーザー同士に対して
            # @roomId = cu.room_idという変数を指定する。
          end
        end
      end
      # 2人のユーザーが使う、Entriesテーブル内の共通するroom_idを特定する
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
    @user = User.find_by(params[:id])
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
