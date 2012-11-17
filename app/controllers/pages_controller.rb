class PagesController < ApplicationController

  # Call the admin.html.erb layout file. If you don't call a specific file
  # Rails will default to using the application.html.erb file.
  layout 'admin'

  before_filter :confirm_logged_in
  before_filter :find_subject

  def index
    list
    render('list')
  end

  def list
    # @pages = Page.order("pages.position ASC").where(:subject_id => @subject.id)
    # Below "sorted" is a scope in the model page.rb
    @pages = Page.sorted.where(:subject_id => @subject.id)
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    # You can set defaults (pre-select it on the form) --> @subject = Subject.new(:name => 'default')
    @page = Page.new(:subject_id => @subject.id)
    @page_count = @subject.pages.size + 1
    @subjects = Subject.order('position ASC')
  end

  def create
    new_position = params[:page].delete(:position)
    # Instantiate a new object using form parameters.
    @page = Page.new(params[:page])
    # Save the object.
    if @page.save
      @page.move_to_position(new_position)
      # If save succeeds, display the flash hash message & redirect to the list action.
      flash[:notice] = "Page created successfully."
      redirect_to(:action => 'index', :subject_id => @page.subject_id)
    else
      # If save fails, redisplay the form so user can fix problems.
      @page_count = @subject.pages.size + 1
      @subjects = Subject.order('position ASC')
      render('new')
      # Because the object Subject has been instantiated, all
      # Values the user typed in will appear in the form again.
    end
  end

  def edit
    @page = Page.find(params[:id])
    @page_count = @subject.pages.size
    @subjects = Subject.order('position ASC')
  end

  def update
    @new_position = params[:page].delete(:position)
    # Find object using form parameters.
    @page = Page.find(params[:id])
    # Update the object.
    if @page.update_attributes(params[:page])
      move_page
    else
      do_not_move_page
    end
  end

  def move_page
    @page.move_to_position(@new_position)
    # If update succeeds, display the flash hash message & redirect to the list action.
    flash[:notice] = "Page updated successfully."
    redirect_to(:action => 'show', :id => @page.id, :subject_id => @page.subject_id)
  end

  def do_not_move_page
    # If save fails, redisplay the form so user can fix problems.
    # :subject_id gets blown away when a blank form field is updated
    # update_attributes is used below to restore the value.
    @page.update_attributes(:subject_id => @page.subject.id)
    # @subject also gets lost on blank form field submission.
    # This fixes the "invalid method 'pages'" problem.
    @subject = Subject.find_by_id(@page.subject.id)
    @page_count = @subject.pages.size
    @subjects = Subject.order('position ASC')
    # Don't use redirect because you will lose all attributes!
    render :edit
    # Because the object Subject has been instantiated, all
    # Values the user typed in will appear in the form again.
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
    @page = Page.find(params[:id])
  end

  def destroy
    # The 2 lines below would work, but because this action
    # isn't calling a template, we don't need to use an @instance variable.
    # @subject = Subject.find(params[:id])
    # @subject.destroy
    @page = Page.find(params[:id])
    move_page_position
    delete_section
  end

  def move_page_position
    @page.move_to_position(nil)
  end

  def delete_section
    @page.destroy
    flash[:notice] = "Page deleted successfully."
    redirect_to(:action => 'index', :subject_id => @subject.id)
  end

  private

  def find_subject
    if params[:subject_id]
      @subject = Subject.find_by_id(params[:subject_id])
    end
  end

end
