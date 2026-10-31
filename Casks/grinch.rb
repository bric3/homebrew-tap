cask "grinch" do
  version "0.9.2"
  sha256 "5f8efeeeff2f1694771b4cb281229b2f3b921af13b32393790e93166020d3ac8"

  url "https://github.com/jamtur01/grinch/releases/download/v#{version}/Grinch-v#{version}.dmg"
  name "Grinch"
  desc "Tiny, fast browser router inspired by Finicky and Finch"
  homepage "https://github.com/jamtur01/grinch"

  depends_on macos: :ventura

  app "Grinch.app"

  zap trash: [
    "~/Library/Application Support/Grinch",
    "~/Library/Preferences/com.grinch.browser.plist",
  ]
end
