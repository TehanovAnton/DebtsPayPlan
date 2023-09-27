# frozen_string_literal: true

module PartialLoaders
  class GroupsPartialsLoader
    include PartialLoaderMethod

    def initialize(partial_path, locals)
      @controller = GroupsController
      @partial_path = partial_path
      @locals = locals
    end

    def load
      @controller.render(
        partial: @partial_path,
        locals: @locals
      )
    end
  end
end
