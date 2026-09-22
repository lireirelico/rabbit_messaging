# frozen_string_literal: true

describe Rabbit::EventHandler do
  let(:parent) do
    Class.new(described_class) do
      queue_as :parent_queue
    end
  end

  it "passes the queue down to a subclass" do
    expect(Class.new(parent).queue).to eq(:parent_queue)
  end

  it "keeps a queue the subclass assigned before calling super" do
    subclass = Class.new(parent) do
      def self.inherited(child)
        child.send(:queue_as, :child_queue)

        super
      end
    end

    expect(Class.new(subclass).queue).to eq(:child_queue)
  end
end
