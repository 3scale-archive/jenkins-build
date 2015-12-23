require 'json'

RSpec.describe Jenkins::Build::TestReport do

  subject(:test_report) { described_class::Builder.new.build_report(json) }
  let(:json) { JSON.parse File.read('testreport.json') }

  it do
    expect(test_report.failures.size).to eq(3)
  end
  it do
    expect(test_report.suites.size).to eq(3)
  end

  it do
    puts test_report.project_path
    puts test_report.failures
  end
end

RSpec.describe Jenkins::Build::TestReport::StackTrace do
  let(:stderr) { 'features/foo/bar.feature:42' }
  subject(:stack_trace) { described_class.new(stderr) }

  it 'handles missing project path' do
    expect(stack_trace.cause(nil)).to eq(stderr)
  end
end


RSpec.describe Jenkins::Build::TestReport::Status do
  let(:stderr) { 'features/foo/bar.feature:42' }
  subject(:stack_trace) { described_class.new(stderr) }

  it 'handles regression' do
    regression = described_class.new('REGRESSION')
    expect(regression).to be_failure
  end

  it 'handles failure' do
    failed = described_class.new('FAILED')
    expect(failed).to be_failure
  end
end
