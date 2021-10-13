cask "samurai" do
  version "2021.9"
  sha256 "2e919c02b4913b580c3016d54429021d46f473b3f24bd16d7f5be44f44f251c1"

  url "https://github.com/yusuke/samurai/releases/download/#{version}/Samurai-#{version}.dmg"
  name "Samurai App"
  desc "Samurai is an analysis tool for Java thread dumps / GC logs."
  homepage "https://github.com/yusuke/samurai"

  app "Samurai.app"
end
