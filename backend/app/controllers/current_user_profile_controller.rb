class CurrentUserProfileController < ApplicationController
    before_action :authorize_request
    # GET /users/current_user
    def show
        user_profile = {}
        user_profile["id"] = @current_user.id
        user_profile["name"] = @current_user.name
        user_profile["email"] = @current_user.email
        user_profile["avatar_url"] = @current_user.avatar_url
        user_profile["posts_count"] = @current_user.posts.count
        user_profile["following_count"] = @current_user.following.count
        user_profile["followers_count"] = @current_user.followers.count
        user_profile["posts"] = []
        sql = " SELECT * 
                FROM   posts
                WHERE  user_profile_id = '#{@current_user.id}'
                ORDER BY created_at DESC"
        posts = Post.paginate_by_sql(sql, page: params[:page], per_page: 5)
        posts.each do |post|
            profile_post = {}
            profile_post[:post_id] = post.id
            profile_post[:image_url] = post.image_url
            user_profile["posts"].push(profile_post)
        end
        render json: user_profile, status: :ok
    end

    def show_following
        following = @current_user.following
        following_info = []
        following.each do |user|
            user_info = {}
            user_info[:id] = user.id
            user_info[:name] = user.name
            user_info[:avatar_url] = user.avatar_url
            following_info.push(user_info)
        end

        render json: following_info, status: :ok
    end

    def show_followers
        followers = @current_user.followers
        followers_info = []
        followers.each do |user|
            user_info = {}
            user_info[:id] = user.id
            user_info[:name] = user.name
            user_info[:avatar_url] = user.avatar_url
            followers_info.push(user_info)
        end

        render json: followers_info, status: :ok
    end

end