json.extract! user, :id, :name, :email, :token, :room_id, :moderator, :created_at, :updated_at
json.url room_user_url(user.room_id, user.id, format: :json)
