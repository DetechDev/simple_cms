require "position_mover"

class Subject < ActiveRecord::Base

  include PositionMover

  has_many :pages

  # Don't need to validate (in most cases):
  #   ids, foreign keys, timestamps, booleans, counters

  # validates_presence_of :name
  # validates_length_of :name, :maximum => 255 # Restrict the name field to the max the database can handle

  # validates_presence_of vs. validates_length_of :minimum => 1
  # different error messages: "can't be blank" or "is too short"
  # validates_length_of allows strings with only spaces!

  validates :name, :presence => true, :length => {:maximum => 255}


  attr_accessible :name, :position, :visible, :created_at

  scope :visible, where(:visible => true)
  scope :invisible, where(:visible => false)
  scope :sorted, order('subjects.position ASC')
  scope :search, lambda {|query| where(["name LIKE ?", "%#{query}%"])}

end
