class Permission < ActiveRecord::Base
  enum level: [:owner, :admin, :contributor]

  belongs_to :project
  belongs_to :user
end
