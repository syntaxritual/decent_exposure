require 'decent_exposure/active_record_with_eager_attributes_strategy'

module DecentExposure
  class ExposureStrategyClassFactory

    attr_accessor :strategizer

    def initialize(strategizer)
      self.strategizer = strategizer
    end

    def strategy_class
      custom_strategy_class || active_record_fallback_strategy_class
    end

    private

    def custom_strategy_class
      strategizer.options[:strategy] if strategizer.has_custom_strategy?
    end

    def active_record_fallback_strategy_class
      ActiveRecordWithEagerAttributesStrategy
    end

  end
end
