# frozen_string_literal: true

# To deliver this notification:
#
# GroupJoinRejectionNotification.with(post: @post).deliver_later(current_user)
# GroupJoinRejectionNotification.with(post: @post).deliver(current_user)

class GroupJoinRejectionNotification < Noticed::Base
  deliver_by :database

  # param :post

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
