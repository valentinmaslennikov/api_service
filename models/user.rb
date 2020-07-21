# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :posts
  has_many :connections

  validates :username, presence: true, uniqueness: true
end
