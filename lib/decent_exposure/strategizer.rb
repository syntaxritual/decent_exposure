require 'decent_exposure/exposure'
require 'decent_exposure/active_record_with_eager_attributes_strategy'
require 'decent_exposure/strong_parameters_strategy'
require 'decent_exposure/object_strategy'

module DecentExposure
  class Strategizer
    attr_accessor :name, :block, :options, :custom_strategy_class,
      :object_strategy_class

    def initialize(name, options={})
      self.name = name
      self.custom_strategy_class = options.delete(:strategy)
      self.object_strategy_class = options.delete(:object)
      self.options = options.merge(:name => name)
      self.block = Proc.new if block_given?
    end

    def strategy
      block_strategy || exposure_strategy
    end

    private

    def exposure_strategy
      Exposure.new(name, exposure_strategy_class, options)
    end

    def block_strategy
      BlockStrategy.new(block) if block
    end

    def exposure_strategy_class
      custom_strategy_class || decent_exposure_strategy_class
    end

    def decent_exposure_strategy_class
      if object_strategy_class
        ObjectStrategy
      else
        ActiveRecordWithEagerAttributesStrategy
      end
    end
  end

  BlockStrategy = Struct.new(:block) do
    def call(controller)
      controller.instance_eval(&block)
    end
  end
end
