class PurlInfo < ApplicationRecord
  has_many :CloneInfos, foreign_key: 'purl_info_id', class_name: "CloneInfo"
  has_many :CloneInfos, foreign_key: 'purl_info_ori_id', class_name: "CloneInfo"
  has_many :PurlMaintainerInfos
  belongs_to :RedirectTypeId, optional: true

  validates :path, presence: true, uniqueness: true
end
