require 'decent_exposure/exposure'
require 'decent_exposure/active_record_with_eager_attributes_strategy'
require 'decent_exposure/strong_parameters_strategy'
require 'decent_exposure/object_strategy'
require 'decent_exposure/exposure_strategy_class_factory'

module DecentExposure
  class Strategizer
    attr_accessor :name, :block, :options

    def initialize(name, options={})
      self.name = name
      self.options = merge_options(options)
      self.block = Proc.new if block_given?
    end

    def strategy
      block_strategy || exposure_strategy
    end

    def has_custom_strategy?
      options[:strategy].present?
    end

    def has_target_object?
      options[:object].present?
    end

    private

    def exposure_strategy
      Exposure.new(name, exposure_strategy_class, options)
    end

    def exposure_strategy_class
      ExposureStrategyClassFactory.new(self).strategy_class
    end

    def block_strategy
      BlockStrategy.new(block) if block
    end

    def merge_options(options)
      options.merge!(object: options.delete(:object))
      options.merge!(strategy: options.delete(:strategy))
      options.merge!(name: name)
    end
  end

  BlockStrategy = Struct.new(:block) do
    def call(controller)
      controller.instance_eval(&block)
    end
  end
end
