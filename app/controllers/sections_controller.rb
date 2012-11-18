class SectionsController < ApplicationController

  # Call the admin.html.erb layout file. If you don't call a specific file
  # Rails will default to using the application.html.erb file.
  layout 'admin'

  before_filter :confirm_logged_in
  before_filter :find_page

  def index
    list
    render('list')
  end

  def list
    # @sections = Section.order("sections.position ASC").where(:page_id => @page.id)
    # Below "sorted" is a scope in the model section.rb
    @sections = Section.sorted.where(:page_id => @page.id)
  end

  def show
    @section = Section.find(params[:id])
  end

  def new
    # You can set defaults --> @subject = Subject.new(:name => 'default')
    @section = Section.new(:page_id => @page.id)
    @section_count = @page.sections.size + 1
    @pages = Page.order('position ASC')
  end

  def create
    new_position = params[:section].delete(:position)
    # Instantiate a new object using form parameters.
    @section = Section.new(params[:section])
    # Save the object.
    if @section.save
      @section.move_to_position(new_position)
      # If save succeeds, display the flash hash message & redirect to the list action.
      flash[:notice] = "Section created successfully."
      redirect_to(:action => 'index', :page_id => @section.page.id)
    else
      # If save fails, redisplay the form so user can fix problems.
      @section_count = @page.sections.size + 1
      @pages = Page.order('position ASC')
      render('new')
      # Because the object Subject has been instantiated, all
      # Values the user typed in will appear in the form again.
    end
  end

  def edit
    @section = Section.find(params[:id])
    @section_count = @page.sections.size
    @pages = Page.order('position ASC')
  end

  def update
    @new_position = params[:section].delete(:position)
    # Find object using form parameters.
    @section = Section.find(params[:id])
    # Update the object.
    if @section.update_attributes(params[:section])
      move_section_position
    else
      do_not_move_section_position
    end
  end

  def move_section_position
    @section.move_to_position(@new_position)
    # If update succeeds, display the flash hash message & redirect to the list action.
    flash[:notice] = "Section updated successfully."
    redirect_to(:action => 'show', :id => @section.id, :page_id => @section.page.id )
  end

  def do_not_move_section_position
    # If save fails, redisplay the form so user can fix problems.
    # :page_id gets blown away when a blank form field is updated
    # update_attributes is used below to restore the value.
    update_attributes
    # @page also gets lost on blank form field submission.
    # This fixes the "invalid method 'pages'" problem.
    @page = Page.find_by_id(@section.page.id)
    @section_count = @page.sections.size
    get_pages
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
    @section = Section.find(params[:id])
  end

  def destroy
    # The 2 lines below would work, but because this action
    # isn't calling a template, we don't need to use an @instance variable.
    # @subject = Subject.find(params[:id])
    # @subject.destroy
    @section = Section.find(params[:id])
    move_to_destroy_position
    delete_section
  end

  def move_to_destroy_position
    @section.move_to_position(nil)
  end

  def delete_section
    @section.destroy
    flash[:notice] = "Section deleted successfully."
    redirect_to(:action => 'index', :page_id => @page.id)
  end

  def update_attributes
    @section.update_attributes(:page_id => @section.page.id)
  end

  def get_pages
    @pages = Page.order('position ASC')
  end

  private

  def find_page
    if params[:page_id]
      @page = Page.find_by_id(params[:page_id])
    end
  end


end
