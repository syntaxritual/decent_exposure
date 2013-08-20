require 'decent_exposure/object_strategy'
require 'decent_exposure/active_record_with_eager_attributes_strategy'
require 'decent_exposure/strong_parameters_strategy'

module DecentExposure
  class ExposureStrategyClassFactory

    attr_accessor :strategizer

    def initialize(strategizer)
      self.strategizer = strategizer
    end

    def strategy_class
      object_strategy_class || custom_strategy_class || strong_parameters_strategy_class || active_record_fallback_strategy_class
    end

    private

    def object_strategy_class
      ObjectStrategy if strategizer.has_target_object?
    end

    def custom_strategy_class
      strategizer.options[:strategy] if strategizer.has_custom_strategy?
    end

    def strong_parameters_strategy_class
      StrongParametersStrategy if ActionController.const_defined? :StrongParameters
    end

    def active_record_fallback_strategy_class
      ActiveRecordWithEagerAttributesStrategy
    end

  end
end
