module DecentExposure
  class ExposureStrategyClassFactory

    attr_accessor :strategizer

    def initialize(strategizer)
      self.strategizer = strategizer
    end

    def strategy_class
      object_strategy_class || custom_strategy_class || active_record_fallback_strategy_class
    end

    private

    def object_strategy_class
      ObjectStrategy if strategizer.has_target_object?
    end

    def custom_strategy_class
      strategizer.options[:strategy] if strategizer.has_custom_strategy?
    end

    def active_record_fallback_strategy_class
      ActiveRecordWithEagerAttributesStrategy
    end

  end
end
