class Reward < ActiveRecord::Base
validates :name, :cost, :presence => true
end
