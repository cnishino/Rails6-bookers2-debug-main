class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :rooms, optional: true

  validates :message, presence: true, length: {maximum: 140}
end
