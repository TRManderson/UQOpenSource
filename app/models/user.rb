class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :permissions
  has_many :projects, through: :permissions

  validates :name, presence: true
  before_save :lower_email

  def self.from_omniauth(auth)
    r=where(provider: auth.provider, uid: auth.uid)
    if r.count == 0
      r=where(email: auth.info.email.downcase)
      if r.count == 0
        user = User.new(provider:auth.provider, uid: auth.uid, email:auth.info.email.downcase,name: auth.info.name)
        user.password = Devise.friendly_token[0,20]
      else
        user=r.first
        user.provider=auth.provider
        user.uid=auth.uid
      end
    else
      user = r.first
    end
    user
  end

  def owner_of?(project)
    p=Permission.where(user_id: self.id, project_id: project.id, level: 0)
    if p.count > 0 then true else nil end
  end

  def level_in(project)
    p=Permission.where(user_id: self.id, project_id: project.id)
    if p.count == 0 then nil else p.first.level end
  end

  def lower_email
    self.email = self.email.downcase
  end
end
