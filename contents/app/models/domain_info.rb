class DomainInfo < ApplicationRecord
  has_many :DomainMaintainerInfos

  validates :name, presence: true, uniqueness: true
  validates :domain_id, presence: true, uniqueness: true
end
