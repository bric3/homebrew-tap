cask "grinch" do
  version "0.8.9"
  sha256 "b5fbc243346fe9ff9b4b23a6de38c749e1f26540e16d4a0b965af93026a98b80"

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
