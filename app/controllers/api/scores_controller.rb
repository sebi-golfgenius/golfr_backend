module Api
  # Controller that handles CRUD operations for scores
  class ScoresController < ApplicationController
    before_action :logged_in!
    before_action :validate_score_user_id, only: :destroy

    def scores_for_user
      user = User.find_by(id: params[:id]) if !user
      if user
        # scores = user.scores.includes(:user)
        scores = Score.where(user_id: user.id).order(played_at: :desc, id: :desc).includes(:user)
        serialized_scores = scores.map(&:serialize_without_user)
        render json: {
          scores: serialized_scores
        }
      else
        render json: {
          errors: "User not found"
        }, status: :bad_request
      end
    end

    def user_feed
      scores = Score.all.order(played_at: :desc, id: :desc).includes(:user)
      serialized_scores = scores.map(&:serialize)

      response = {
        scores: serialized_scores,
      }

      render json: response.to_json
    end

    def create
      score = current_user.scores.build(score_params)

      if score.save
        render json: {
          score: score.serialize
        }
      else
        render json: {
          errors: score.errors.messages
        }, status: :bad_request
      end
    end

    def destroy
      @score.destroy!

      render json: {
        score: @score.serialize
      }
    end

    private

    def score_params
      params.require(:score).permit(:total_score, :played_at)
    end

    def validate_score_user_id
      @score = Score.find(params[:id])

      return if @score.user_id == current_user.id

      render json: {
        errors: [
          'Score does not belong to user'
        ]
      }, status: :unauthorized
    end
  end
end
