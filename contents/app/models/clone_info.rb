class CloneInfo < ApplicationRecord
  belongs_to :PurlInfo, foreign_key: 'purl_info_id', class_name: "PurlInfo"
  belongs_to :PurlInfo, foreign_key: 'purl_info_ori_id', class_name: "PurlInfo"
end
