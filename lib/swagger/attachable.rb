module Swagger
  # A module that attaches parent objects to their children so you can navigate back
  # up the hierarchy.
  module Attachable
    # The top-level object in the hierarchy.
    attr_accessor :children
    def root
      return self if parent.nil?
      parent.root
    end

    # @api private
    def attach_parent(parent)
      @parent = parent
      attach_to_children
    end

    # @api private
    def attach_to_children
      @children ||= []
      each_value do |v| # rubocop:disable Style/Next
        if v.respond_to? :attach_parent
          v.attach_parent self
          self.children << v
          self.children.uniq!
        end
        if v.respond_to? :each_value
          v.each_value do |sv|
            sv.attach_parent self if sv.respond_to? :attach_parent
          end
        end
        if v.respond_to? :each
          v.each do |sv|
            sv.attach_parent self if sv.respond_to? :attach_parent
          end
        end
      end
    end
  end
end
