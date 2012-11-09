class AdminUsersController < ApplicationController

  # Call the admin.html.erb layout file. If you don't call a specific file
  # Rails will default to using the application.html.erb file.
  layout 'admin'

  before_filter :confirm_logged_in

  def index
    list
    render('list')
  end

  def list
    @admin_users = AdminUser.sorted
  end

  def new
    # You can set defaults --> @subject = Subject.new(:name => 'default')
    @admin_user = AdminUser.new
  end

  def create
    # Instantiate a new object using form parameters.
    @admin_user = AdminUser.new(params[:admin_user])
    # Save the object.
    if @admin_user.save
      # If save succeeds, display the flash hash message & redirect to the list action.
      flash[:notice] = "Admin user created successfully."
      redirect_to(:action => 'index')
    else
      # If save fails, redisplay the form so user can fix problems.
      render('new')
      # Because the object Subject has been instantiated, all
      # Values the user typed in will appear in the form again.
    end
  end

  def edit
    @admin_user = AdminUser.find(params[:id])
  end

  def update
    # Find object using form parameters.
    @admin_user = AdminUser.find(params[:id])
    # Update the object.
    if @admin_user.update_attributes(params[:admin_user])
      # If update succeeds, display the flash hash message & redirect to the list action.
      flash[:notice] = "Admin User updated successfully."
      redirect_to(:action => 'index')
    else
      # If save fails, redisplay the form so user can fix problems.
      render('edit')
      # Because the object Subject has been instantiated, all
      # Values the user typed in will appear in the form again.
    end
  end

  #def delete
  #  @subject = Subject.find(params[:id])
  #  if @subject.destroy
  #    redirect_to(:action => 'list')
  #  else
  #    render('list')
  #  end
  #end

  def delete
    @admin_user = AdminUser.find(params[:id])
  end

  def destroy
    # The 2 lines below would work, but because this action
    # isn't calling a template, we don't need to use an @instance variable.
    # @subject = Subject.find(params[:id])
    # @subject.destroy
    AdminUser.find(params[:id]).destroy
    flash[:notice] = "Admin User deleted successfully."
    redirect_to(:action => 'index')
  end

end
