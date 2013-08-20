require 'decent_exposure/exposure_strategy_class_factory'
require 'action_controller'

class FooStrategy; end

describe DecentExposure::ExposureStrategyClassFactory do

  describe "#strategy_class" do
    subject { described_class.new(strategizer).strategy_class }
    let(:strategizer) { double('strategizer') }

    context "with custom strategy class specified" do
      before { strategizer.stub(has_custom_strategy?: true, has_target_object?: false, options: { strategy: FooStrategy }) }
      it { should == FooStrategy }
    end

    context "no strategy specified" do
      before do
        strategizer.stub(has_custom_strategy?: false)
        ActionController.should_receive(:const_defined?).with(:StrongParameters).and_return(false)
      end
      it { should == DecentExposure::ActiveRecordWithEagerAttributesStrategy }
    end
  end

end
