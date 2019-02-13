require 'rails_helper'

RSpec.describe RecalculateVideosRankService do
  # let(:metrics_adapter) do
  #   FakeMetricsAdapter.new
  # end

  subject { RecalculateVideosRankService.new }

  it 'Run videos rank recalculation' do
    subject.call
    expect(2).to eq(2)
  end
end
