# frozen_string_literal: true

cask "invoicy" do
  version "0.11.1"
  sha256 "8f7e5ab6277d01f13511648475370b7100e04f2583f535465dfbbf6f704ad8b3"

  url "https://releases.r5n.dev/invoicy/Invoicy-#{version}-macos-arm64.dmg"
  name "Invoicy"
  desc "Local-first invoicing for Polish sole proprietors"
  homepage "https://r5n.dev/"

  livecheck do
    url "https://releases.r5n.dev/invoicy/stable-macos-arm64-update.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "Invoicy.app"

  zap trash: [
    "~/Library/Application Support/dev.r5n.invoicy",
    "~/Library/Preferences/dev.r5n.invoicy.plist",
  ]
end
