# frozen_string_literal: true

class Connection < ActiveRecord::Base
  belongs_to :user
end
