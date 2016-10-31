require "spec_helper"

describe Http::Server do
  it "has a version number" do
    expect(Http::Server::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
