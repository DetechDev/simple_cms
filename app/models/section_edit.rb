class SectionEdit < ActiveRecord::Base
  attr_accessible :admin_user_id, :section_id, :summary, :editor, :section

  # belongs_to :admin_user
  # When changing the name to "editor" below, you have to specify the class_name AND
  # the foreign_key name!
  belongs_to :editor, :class_name => "AdminUser", :foreign_key => 'admin_user_id'
  belongs_to :section

end
