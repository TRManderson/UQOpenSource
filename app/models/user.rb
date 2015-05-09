class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :permissions
  has_many :projects, through: :permissions

  def self.from_omniauth(auth)  
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      puts auth.info
      user.password = Devise.friendly_token[0,20]
    end
  end

  def owner_of?(project)
    p=Permission.where(user_id: self.id, project_id: project.id, level: 0)
    if p.count > 0 then true else nil end
  end

  def level_in(project)
    p=Permission.where(user_id: self.id, project_id: project.id)
    if p.count == 0 then nil else p.first.level end
  end
end
