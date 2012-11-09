require 'position_mover'

class Page < ActiveRecord::Base

  include PositionMover

  belongs_to :subject
  has_many :sections
  # has_and_belongs_to_many :admin_users
  # The above line will work, but it may be unclear.
  # It may be more clear to use "editors" instead of "admin_users"
  # You can change the name, but if you to you need to specify the class:

  has_and_belongs_to_many :editors, :class_name => "AdminUser"

  #validates_presence_of :name
  #validates_length_of :name, :maximum => 255
  #validates_presence_of :permalink
  #validates_length_of :permalink, :within => 3..255

  # use presence with length to disallow spaces
  #validates_uniqueness_of :permalink
  # for unique values by subject, :scope => :subject_id


  validates :name, :presence => true, :length => {:maximum => 255}
  validates :permalink, :presence => true, :length => 3..255, :uniqueness => true

  attr_accessible :name, :permalink, :position, :visible, :subject_id

  scope :visible, where(:visible => true)
  scope :invisible, where(:visible => false)
  scope :sorted, order('pages.position ASC')

  private

  def position_scope
    "pages.subject_id = #{subject_id.to_i}"
  end

end
