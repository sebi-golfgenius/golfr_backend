module Api
  # Controller that handles authorization and user data fetching
  class UsersController < ApplicationController
    include Devise::Controllers::Helpers

    before_action :logged_in!, only: :show

    def login
      user = User.find_by('lower(email) = ?', params[:email])

      if user.blank? || !user.valid_password?(params[:password])
        render json: {
          errors: [
            'Invalid email/password combination'
          ]
        }, status: :unauthorized
        return
      end

      sign_in(:user, user)

      render json: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          token: current_token
        }
      }.to_json
    end

    def show
      single_user = User.find_by(id: params[:id])

      if single_user.nil?
        render json: {
          errors: 'User not found'
        }, status: :bad_request
      else
        render json: {
          user: {
            id: single_user[:id],
            name: single_user[:name]
          }
        }
      end
    end
  end
end
