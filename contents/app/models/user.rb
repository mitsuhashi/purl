class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # deviseでemailを不必要にする
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def active_for_authentication?
    super and self.allowed_to_log_in? and self.group_flag == false and self.disable_flag == false
  end

  def inactive_message
    "You are not allowed to log in."
  end

  validates :fullname, presence: true
  validates :username, presence: true, uniqueness: true
  #validates :password, confirmation: true

  has_many :GroupInfos, foreign_key: 'group_id', class_name: "GroupInfo"
  has_many :GroupInfos, foreign_key: 'user_id', class_name: "GroupInfo"
  has_many :GroupMaintainerInfos, foreign_key: 'group_id', class_name: "GroupMaintainerInfo"
  has_many :GroupMaintainerInfos, foreign_key: 'user_id', class_name: "GroupMaintainerInfo"
  has_many :PurlMaintainerInfos
  has_many :DomainMaintainerInfos
end
