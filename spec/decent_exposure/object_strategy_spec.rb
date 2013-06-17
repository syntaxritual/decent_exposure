require 'decent_exposure/object_strategy'
require 'active_support/core_ext'

class Model; end

def new_strategy(args)
  DecentExposure::ObjectStrategy.new(controller, nil, args)
end

describe DecentExposure::ObjectStrategy do
  describe "#resource" do

    let(:object) { Model }
    let(:params) { Hash.new }
    let(:request) { double(:get? => true) }
    let(:config) { double(:options => {}) }
    let(:controller_class) { double('controller_class', :_decent_configurations => Hash.new(config)) }
    let(:controller) { double('controller', :params => params, :request => request, :class => controller_class) }
    let(:instance) { double('instance') }

    subject { strategy.resource }

    context "using object strategy" do
      let(:strategy) { new_strategy(object: object, arguments: 'bar') }

      context "constant resolving" do
        let(:object) { :model }

        it "handles objects when given as a symbol" do
          Model.should_receive(:new).with('bar').and_return(instance)
          should == instance
        end
      end

      context "with a provided method" do
        let(:strategy) { new_strategy(object: object, method: :foo, arguments: 'bar') }

        it "it calls method on object class with arguments" do
          object.should_receive(:foo).with('bar').and_return(instance)
          should == instance
        end
      end

      context "without a provided method" do
        let(:strategy) { new_strategy(object: object, arguments: 'bar') }

        it "uses new as a default method" do
          object.should_receive(:new).with('bar').and_return(instance)
          should == instance
        end
      end
    end
  end
end
