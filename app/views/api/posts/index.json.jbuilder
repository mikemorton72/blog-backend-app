json.array! @posts.each do |post|
  json.id post.id
  json.title post.title
  json.body post.body
  json.image post.image
  json.user User.find_by(id: post.user_id)
end
