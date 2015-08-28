RSpec.describe Jenkins::Build do
  it 'has a version number' do
    expect(Jenkins::Build::VERSION).not_to be nil
  end
end
