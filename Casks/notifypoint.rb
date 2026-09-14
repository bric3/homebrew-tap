cask "notifypoint" do
  version :latest
  sha256 :no_check

  url "https://github.com/bric3/NotifyPoint/archive/refs/heads/master.tar.gz"
  name "NotifyPoint"
  desc "Control notification position"
  homepage "https://github.com/bric3/NotifyPoint"

  depends_on macos: :sonoma

  app "NotifyPoint-master/NotifyPoint.app", target: "~/Applications/NotifyPoint.app"

  preflight_steps do
    run "/usr/bin/make",
        args:         ["build"],
        chdir:        "NotifyPoint-master",
        print_stdout: true
  end

  uninstall launchctl: "io.github.bric3.notifypoint",
            quit:      "io.github.bric3.notifypoint"

  caveats do
    puts <<~EOS
      NotifyPoint is built from the latest source with an ad-hoc signature and is not notarized.
      If macOS blocks the app, allow it in:
        System Settings → Privacy & Security
    EOS

    unsigned_accessibility
  end
end
