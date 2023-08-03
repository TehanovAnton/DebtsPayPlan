# frozen_string_literal: true

module Services
  class DestroyDirector
    def destroy
      subscribe_listeners
      destroyer.destroy
      publish_destroy
    end
  end
end
