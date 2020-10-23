class User < ApplicationRecord
  belongs_to :room

  attribute :token, :string, default: -> { SecureRandom.hex(16).to_i(16).to_s(36) }
  attribute :moderator, :boolean, default: false
  attribute :invited, :boolean, default: false
  attribute :vote, :boolean, default: true
  attribute :proxy, :boolean, default: false
end
