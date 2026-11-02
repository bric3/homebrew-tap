class Awaken < Formula
  desc "Timed sleep prevention with lid-close support for macOS"
  homepage "https://github.com/bric3/awaken"
  # Git metadata is required to embed the release version.
  url "https://github.com/bric3/awaken.git",
      tag:      "v0.1.0",
      revision: "0a484a5076012029bad1002f1e17640a5a5c062a"
  license "MPL-2.0"

  depends_on macos: :ventura
  uses_from_macos "swift" => :build

  def install
    ENV["AWAKEN_RELEASE_TAG"] = "v#{version}"
    system "swift", "build", *std_swift_args, "--product", "awaken"
    bin.install ".build/release/awaken"
  end

  def caveats
    <<~EOS
      To enable --ignore-lid, install the privileged worker and its sudoers rule:
        eval "$(#{opt_bin}/awaken sudoers)"

      Setup authenticates through sudo. Rerun it after upgrades to update the worker.
      Run sessions directly after setup:
        awaken --ignore-lid -t 1h
    EOS
  end

  test do
    assert_equal "awaken #{version}\n", shell_output("#{bin}/awaken --version")
    system bin/"awaken", "--timeout", "1s", "--no-countdown"
  end
end
