# frozen_string_literal: true

RSpec.describe MemoizeAs do
  let(:memoizeable_class) do
    Class.new do
      include MemoizeAs

      attr_reader :numbers, :block_run_count

      def first_even
        memoize_as(:@first_even) do
          @block_run_count = @block_run_count.to_i + 1
          numbers.find { |n| n.even? }
        end
      end
    end
  end

  subject { memoizeable_class.new }

  context 'with at least one even number' do
    before { allow(subject).to receive(:numbers).and_return([1, 2, 3, 5, 7, 9]) }

    it { expect(subject.first_even).to eq 2 }

    it 'when asking multiple times, only runs the block once' do
      Array.new(3) { expect(subject.first_even).to eq 2 }
      expect(subject.block_run_count).to eq 1
    end
  end

  context 'with no even numbers' do
    before { allow(subject).to receive(:numbers).and_return([1, 3, 5, 7, 9]) }

    it { expect(subject.first_even).to eq nil }

    it 'when asking multiple times, only runs the block once' do
      Array.new(3) { expect(subject.first_even).to be_nil }
      expect(subject.block_run_count).to eq 1
    end
  end
end
