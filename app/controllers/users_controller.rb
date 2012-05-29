class UsersController < ApplicationController

  def index
    if params[:approved] == "false"
      @users = User.find_all_by_approved(false)
    else
      @users = User.all
    end
    render :layout => 'admin'
  end

  def destroy
    if user_signed_in?
      logger.info "User #{current_user.email} ask to destroy: #{current_user.email}"
      @user = User.find(params[:id])
      if current_user.id ==  @user.id
        @user.destroy
        cookies[:fb_token]=nil
        sign_out_and_redirect(root_path)
      elsif current_user.admin
        @user.destroy
        flash[:notice]="Usuario borrado"
        redirect_to :back
      else
        logger.info "El usuario no tiene permisos para remover al usuario"
        flash[:notice]="Usuario borrado"
        redirect_to :back
      end
    else
      flash[:alert]= t "devise.user.sessions.unauthenticated"
      redirect_to new_user_session_path
    end
  end

  def approve
    @user = User.find params[:id]
    @user.approve!
    @user.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

  def confirm
    @user = User.find params[:id]
    @user.skip_confirmation!
    @user.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

  def toggle_recommendations
    current_user.email_recommendations = !current_user.email_recommendations
    current_user.save
    respond_to do |format|
      format.js do
        render :update do |page|
          page << "$('#email_recommendations').html('#{current_user.email_recommendations ? "Desuscribir" : "Suscribir" }')"
        end
      end
    end
  end

  def send_confirmation
    @user = User.find params[:id]
    @user.update_attributes params[:user]
    if @user.save
     @user.send_confirmation_instructions
    #@user = User.send_confirmation_instructions(params[:user])
      set_flash_message :notice, :send_instructions
      redirect_to :action => :edit
    else
      render :edit
    end
  end

end