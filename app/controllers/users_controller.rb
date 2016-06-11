class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update, :destroy, :following, :followers]
  before_action :signed_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @tweet = current_user.tweets.build if signed_in?
    @feed_items = @user.tweets.paginate(page: params[:page])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Twitter Clone!"
      
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
		
		uploaded_io = params[:user][:picture]
		params[:user][:picture] = uploaded_io.original_filename
		if @user.update(user_params)
		  flash[:success] = "Update your profile"
		  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
			file.write(uploaded_io.read)
			redirect_to @user
		  end
		  
		else
		  render :edit
		end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to root_url
  end

  def following
    @title = "Following"
    @users = @user.followed_users.paginate(page: params[:page])
    render :show_follow
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render :show_follow
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by!(slug: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :picture, :password_confirmation, :slug)
    end

    def correct_user
      redirect_to(signin_url) unless current_user?(@user)
    end

end
