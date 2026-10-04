cask "grinch" do
  version "0.8.8"
  sha256 "e3647899dfedfcb7d4d35576c4c20139d3bbe63e0ac141ec5cb7418fc2e7027d"

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
