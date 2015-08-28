
RSpec.describe Jenkins::Build::Hub do
  subject(:hub) { described_class.new }

  describe '#ci_status' do
    subject { hub.ci_status }

    before do
      expect(described_class).to receive(:execute).and_return('success: http://example.com')
    end

    it 'returns a ci status' do
      is_expected.to be_a(Jenkins::Build::Hub::CiStatus)
    end

    it { expect(subject.status).to eq('success') }
    it { expect(subject.build).to be_a(Jenkins::Build::Build) }
  end # ci_status
end

RSpec.describe Jenkins::Build::Hub::CiStatus do
  describe 'error' do
    let(:build) { instance_double(Jenkins::Build::Build) }
    subject { described_class.new(status, build) }

    let(:status) { 'error' }

    it 'has url' do
      expect(subject.build).to be(build)
    end

    it 'has status' do
      expect(subject.status).to eq(status)
    end
  end

  describe '.parse' do
    let(:build_url) { 'http://jenkins.example.com/job/jenkins-build/25' }
    subject(:parse) { described_class.parse(output) }

    describe 'success' do
      let(:output) { "success: #{build_url}" }

      context 'status' do
        subject(:status) { parse[0] }
        it { is_expected.to eq('success')}
      end

      context 'build' do
        subject(:build) { parse[1] }
        it { expect(build.number).to eq(25) }
        it { expect(build.job).to eq('jenkins-build') }
      end
    end
  end
end
