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
    new_position = params[:section].delete(:position)
    # Find object using form parameters.
    @section = Section.find(params[:id])
    # Update the object.
    if @section.update_attributes(params[:section])
      @section.move_to_position(new_position)
      # If update succeeds, display the flash hash message & redirect to the list action.
      flash[:notice] = "Section updated successfully."
      redirect_to(:action => 'show', :id => @section.id, :page_id => @section.page.id )
    else
      # If save fails, redisplay the form so user can fix problems.
      @section_count = @page.sections.size
      @pages = Page.order('position ASC')
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
    @section = Section.find(params[:id])
  end

  def destroy
    # The 2 lines below would work, but because this action
    # isn't calling a template, we don't need to use an @instance variable.
    # @subject = Subject.find(params[:id])
    # @subject.destroy
    section = Section.find(params[:id])
    section.move_to_position(nil)
    section.destroy
    flash[:notice] = "Section deleted successfully."
    redirect_to(:action => 'index', :page_id => @page.id)
  end

  private

  def find_page
    if params[:page_id]
      @page = Page.find_by_id(params[:page_id])
    end
  end


end
