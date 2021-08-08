require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "returns array of posts" do
      user = User.create!(
        name: 'Mike',
        email: 'mike@website.com',
        password: 'password'
      )
      Post.create!(
        user_id: user.id,
        title: 'A random Post',
        body: 'interesting stuff about interesting things',
        image: 'image.com'
      )
      Post.create!(
        user_id: user.id,
        title: 'A random Post'.reverse,
        body: 'interesting stuff about interesting things'.reverse,
        image: 'image.com'.reverse
      )
      get '/posts'
      posts = JSON.parse(response.body)
      # p posts
      expect(posts.length).to eq(2)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /posts" do
    it "creates a new post in db" do
      user = User.create!(
        name: 'Mike',
        email: 'mike@website.com',
        password: 'password'
      )
      jwt = JWT.encode(
        {
          user: user.id, # the data to encode
          exp: 24.hours.from_now.to_i # the expiration time
        },
        "random", # the secret key
        'HS256' # the encryption algorithm
      )
      post '/posts', params: {title: 'post creation test', body: 'some test body text', image: 'image.com2'}, headers: {"Authorization" => "Bearer #{jwt}"}
      expect(response).to have_http_status(200)
    end

    it "creates a new post in db, invalid params" do
      user = User.create!(
        name: 'Mike',
        email: 'mike@website.com',
        password: 'password'
      )
      jwt = JWT.encode(
        {
          user: user.id, # the data to encode
          exp: 24.hours.from_now.to_i # the expiration time
        },
        "random", # the secret key
        'HS256' # the encryption algorithm
      )
      post '/posts', params: {body: 'some test body text', image: 'image.com2'}, headers: {"Authorization" => "Bearer #{jwt}"}
      expect(response).to have_http_status(400)
    end

    it "creates a new post in db, no jwt" do
      user = User.create!(
        name: 'Mike',
        email: 'mike@website.com',
        password: 'password'
      )
      post '/posts', params: {body: 'some test body text', image: 'image.com2'}
      expect(response).to have_http_status(401)
    end
  end
  
end
