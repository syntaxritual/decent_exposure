require 'decent_exposure/strategy'

module DecentExposure
  class ObjectStrategy < Strategy

    def initialize(controller, name, options={})
      @object, @arguments, @method = options[:object], options[:arguments], options[:method]
      super(controller, name, options)
    end

    def resource
      evaluated_arguments =
        controller.respond_to?(arguments) ? controller.instance_eval(arguments.to_s) : arguments
      object.send(method, evaluated_arguments)
    end

    private
    attr_reader :arguments

    def object
      @resolved_object ||= DecentExposure::ConstantResolver.new(@object.to_s).constant
    end

    def method
      @method || :new
    end
  end
end
