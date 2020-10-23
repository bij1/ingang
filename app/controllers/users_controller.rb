class UsersController < ApplicationController
  http_basic_authenticate_with name: Rails.application.config.admin_name,
                               password: Rails.application.config.admin_password

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.where(room_id: params[:room_id])
  end

  # POST /users/invite
  def invite
    @users = User.where(room_id: params[:room_id], invited: false, proxy: false)
    @users.each do |user|
      url = join_room_url(user.token)
      RoomMailer.with(user: user, url: url).invite.deliver_now
    end
    count = @users.length
    @users.in_batches.update_all(invited: true)
    respond_to do |format|
      format.html { redirect_to room_users_url, notice: "Sent invitation to #{count} users." }
      format.json { head :no_content }
    end
  end

  # DELETE /users/invite
  def uninvite
    @users = User.where(room_id: params[:room_id], invited: true)
    count = @users.length
    @users.in_batches.update_all(invited: false)
    respond_to do |format|
      format.html { redirect_to room_users_url, notice: "Reset invitation status of #{count} users." }
      format.json { head :no_content }
    end
  end

  
  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.room_id = params[:room_id]

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user.id), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to room_users_url(@user.room_id), notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /users/bulk
  def bulk
  end

  # POST /users/bulk
  # POST /users/bulk..json
  def create_bulk
    room_id = params[:room_id]
    users_csv = params[:users_csv]

    require 'csv'

    CSV.parse(users_csv, :headers => true) do |row|
      fields = row.to_hash
      fields[:room_id] = room_id
      User.create!(fields)
    end

    respond_to do |format|
      format.html { redirect_to room_users_url(room_id), notice: 'Users were successfully created.' }
      format.json { render :show, status: :created, location: @user }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :token, :moderator, :invited, :vote, :proxy)
    end
end
