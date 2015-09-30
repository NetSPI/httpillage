class ResponseFlag < ActiveRecord::Base
  belongs_to :job
  belongs_to :node
end