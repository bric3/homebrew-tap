cask "grinch" do
  version "0.7.0"
  sha256 "403c8b783a376d7f3389d6fde61e87c1f4ad8946da16361d29b339e68c1e809a"

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
