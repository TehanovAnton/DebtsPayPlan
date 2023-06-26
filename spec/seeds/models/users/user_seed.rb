# frozen_string_literal: true

module Seeds
  module Models
    module Users
      class UserSeed
        attr_reader :users, :user

        def initialize(quantity = 0, merge_users: [])
          @quantity = quantity
          @merge_users = merge_users
        end

        def create
          return @user if @user

          @user = FactoryBot.create(:user)
        end

        def create_list
          return @user if @users

          @users = FactoryBot.create_list(:user, @quantity)
          @users |= @merge_users if @merge_users
        end

        def users_collection
          create_list unless @users

          User.where(id: @users.pluck(:id))
        end
      end
    end
  end
end
