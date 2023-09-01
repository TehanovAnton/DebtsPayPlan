# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Dry::Monads[:maybe, :result]

    identified_by :signed_user

    def connect
      self.signed_user = find_signed_user
    end

    def find_signed_user
      return maybe_signed_user.value! unless maybe_signed_user.none?

      reject_unauthorized_connection
    end

    def maybe_signed_user
      @maybe_signed_user ||= Maybe(User.find_by(id: cookies[:current_user_id].to_i))
    end
  end
end
