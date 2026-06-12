class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, except: [ :show ]
  before_action :set_user, only: [ :show, :destroy, :update_roles ]

  def index
    @users = policy_scope(User).page(params[:page]).per(10)
    authorize User
  end

  def show
    authorize @user
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to users_path, notice: "User deleted."
  end

  def new
  @user = User.new
  authorize @user
  end

  def admin_create
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(16)
    @user.skip_confirmation!
    @user.skip_default_role = true
    authorize @user, :create?
    selected_roles = params[:user][:roles] || []
    if selected_roles.include?("admin") && selected_roles.size > 1
      @user.errors.add(:base, "Admin role cannot be combined with other roles. Please unselect others.")
      render :new, status: :unprocessable_entity
      return
    end
    if @user.save
      selected_roles.each { |role| assign_role(@user, role) }
      @user.send_reset_password_instructions
      redirect_to users_path, notice: "User created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update_roles
    authorize @user
    selected = (params[:role_names] || []) & [ "attendee", "organizer", "admin" ]
    if selected.include?("admin") && selected.size > 1
      redirect_to @user, alert: "Admin role cannot be combined with other roles. Please unselect others."
      return
    end
    @user.user_roles.joins(:role).where(roles: { name: [ "attendee", "organizer", "admin" ] }).destroy_all
    selected.each do |name|
      role = Role.find_by(name: name)
      @user.roles << role if role
    end
    redirect_to @user, notice: "Roles updated."
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def assign_role(user, role_name)
    role = Role.find_by(name: role_name)
    user.roles << role if role
  end

  def user_params
  params.require(:user).permit(:name, :email)
  end

  def authorize_admin
    unless current_user.roles.exists?(name: "admin")
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
