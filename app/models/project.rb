class Project < ActiveRecord::Base
  validates :title, presence: true
  has_many :links, dependent: :destroy
  has_many :permissions
  has_many :users, through: :permissions
  accepts_nested_attributes_for :links, allow_destroy: true
end
