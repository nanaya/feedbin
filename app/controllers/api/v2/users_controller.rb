module Api
  module V2
    class UsersController < ApiController

      respond_to :json

      before_action :validate_content_type, only: [:create]
      skip_before_action :authorize, only: [:create]

      def create
        @user = User.new(user_params)
        @user.plan = Plan.find_by_stripe_id('trial')
        @user.password_confirmation = user_params.try(:user).try(:password)
        if @user.save
          render nothing: true
        else
          render json: { errors: @user.errors.full_messages.uniq }
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end

    end
  end
end
