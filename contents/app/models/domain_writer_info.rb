class DomainWriterInfo < ApplicationRecord
  belongs_to :DomainInfo, optional: true
  belongs_to :User, optional: true
end
