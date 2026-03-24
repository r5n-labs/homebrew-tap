cask "invoicy" do
  version "0.9.9"
  sha256 :no_check

  url "https://releases.r5n.dev/Invoicy-macos-arm64.dmg"
  name "Invoicy"
  desc "Desktop invoicing app for Polish JDG sole proprietors"
  homepage "https://r5n.dev/invoicy"

  depends_on macos: ">= :ventura"

  app "Invoicy.app"

  zap trash: [
    "~/Library/Application Support/dev.r5n.invoicy",
    "~/Library/Preferences/dev.r5n.invoicy.plist",
  ]

  livecheck do
    url "https://releases.r5n.dev/Invoicy-macos-arm64.json"
    strategy :json do |json|
      json["version"]
    end
  end
end
