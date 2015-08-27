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
