class User < ApplicationRecord
  has_many :surveys, dependent: :destroy

  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]

    user = self.find_or_initialize_by(provider: provider, uid: uid)
    user.update(
      {
        email: auth[:info][:email],
        name: auth[:info][:name],
        image: auth[:info][:image],
      },
    )
    return user
  end
end
