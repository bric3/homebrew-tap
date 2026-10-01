cask "grinch" do
  version "0.8.7"
  sha256 "e9e2a2e051aeb5a0a4c82d8930e3fdf360a3d5e273a6b7ca3bba2c8dd26cc10b"

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
