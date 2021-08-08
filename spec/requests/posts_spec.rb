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
      p posts
      expect(posts.length).to eq(2)
      expect(response).to have_http_status(200)
    end
  end
end
