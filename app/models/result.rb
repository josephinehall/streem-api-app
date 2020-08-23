class Result < ApplicationRecord
  validates_presence_of :query, :before, :after, :interval
end
