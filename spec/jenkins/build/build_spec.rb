RSpec.describe Jenkins::Build::Build do

  subject(:build) { described_class.new(url) }

  %w[/job/some-build/25 /jobs/some-build/25/ /jobs/some-build/lastBuild].each do |url|
    context url do
      let(:url) { url }

      it { expect(build.job).to eq('some-build') }
      it { expect(build.number).to be }
    end
  end

  context '/job/some-build/25' do
    url = description
    let(:url) { url }
    it { expect(build.number).to eq(25) }
  end

  context '/job/some-build/lastBuild' do
    url = description
    let(:url) { url }
    it { expect(build.number).to eq('lastBuild') }
  end
end
