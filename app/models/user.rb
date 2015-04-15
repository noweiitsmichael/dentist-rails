class User < ActiveRecord::Base
  has_many :practices

  validates_uniqueness_of :email
end
