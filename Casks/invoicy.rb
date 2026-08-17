# frozen_string_literal: true

cask "invoicy" do
  version "0.10.1"
  sha256 "7d0aeb5b006ea8510c058d1a2b1125b6af069b09befee7e812f3ef5675cbb49a"

  url "https://releases.r5n.dev/invoicy/Invoicy-#{version}-macos-arm64.dmg"
  name "Invoicy"
  desc "TBA"
  homepage "https://r5n.dev/"

  livecheck do
    url "https://releases.r5n.dev/invoicy/stable-macos-arm64-update.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :ventura

  app "Invoicy.app"

  zap trash: [
    "~/Library/Application Support/dev.r5n.invoicy",
    "~/Library/Preferences/dev.r5n.invoicy.plist",
  ]
end
