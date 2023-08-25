class GroupCostsChannel < ApplicationCable::Channel
  include Dry::Monads[:maybe, :result]

  def subscribed
    stream_from "group_costs_#{params[:room]}" unless maybe_room.none?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def maybe_room
    @maybe_room ||= Maybe(params[:room])
  end
end
