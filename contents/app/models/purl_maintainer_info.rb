class PurlMaintainerInfo < ApplicationRecord
  belongs_to :PurlInfo, optional: true
  belongs_to :User, optional: true
end
