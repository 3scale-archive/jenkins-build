require 'spec_helper'

describe Jenkins::Build do
  it 'has a version number' do
    expect(Jenkins::Build::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
