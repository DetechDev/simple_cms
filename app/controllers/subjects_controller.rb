class SubjectsController < ApplicationController

  # Call the admin.html.erb layout file. If you don't call a specific file
  # Rails will default to using the application.html.erb file.
  layout 'admin'

  before_filter :confirm_logged_in

  def index
    list            # Call the "list" action below
    render('list')  # Load the "list.html.erb" template instead of the default "index.html.erb" template.
  end

  def list
    # @subjects = Subject.order("subjects.position ASC")
    # Below "sorted" is a scope in the model subject.rb
    @subjects = Subject.sorted
  end

  def show
    @subject = Subject.find(params[:id])
  end

  def new
    # You can set defaults --> @subject = Subject.new(:name => 'default')
    @subject = Subject.new
    @subject_count = Subject.count + 1
  end

  def create
    new_position = params[:subject].delete(:position)
    # Instantiate a new object using form parameters.
    @subject = Subject.new(params[:subject])
    # Save the object.
    if @subject.save
      @subject.move_to_position(new_position)
      # If save succeeds, display the flash hash message & redirect to the list action.
      flash[:notice] = "Subject created successfully."
      redirect_to(:action => 'index')
    else
      # If save fails, redisplay the form so user can fix problems.
      @subject_count = Subject.count + 1
    render('new')
    # Because the object Subject has been instantiated, all
    # Values the user typed in will appear in the form again.
    end
  end

    def edit
      @subject = Subject.find(params[:id])
      @subject_count = Subject.count
    end

    def update
      new_position = params[:subject].delete(:position)
      # Find object using form parameters.
      @subject = Subject.find(params[:id])
      # Update the object.
      if @subject.update_attributes(params[:subject])
        @subject.move_to_position(new_position)
        # If update succeeds, display the flash hash message & redirect to the list action.
        flash[:notice] = "Subject updated successfully."
        redirect_to(:action => 'show', :id => @subject.id)
      else
        # If save fails, redisplay the form so user can fix problems.
        @subject_count = Subject.count
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
    @subject = Subject.find(params[:id])
  end

  def destroy
    # The 2 lines below would work, but because this action
    # isn't calling a template, we don't need to use an @instance variable.
    # @subject = Subject.find(params[:id])
    # @subject.destroy
    subject = Subject.find(params[:id])
    subject.move_to_position(nil)
    subject.destroy
    flash[:notice] = "Subject deleted successfully."
    redirect_to(:action => 'index')
  end


end
