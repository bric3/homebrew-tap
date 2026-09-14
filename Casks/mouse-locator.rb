cask "mouse-locator" do
  version :latest
  sha256 :no_check

  url "https://github.com/bric3/macos-mouse-locator/archive/refs/heads/main.tar.gz"
  name "Mouse Locator"
  desc "Make the mouse pointer easier to locate"
  homepage "https://github.com/bric3/macos-mouse-locator"

  depends_on macos: :sonoma

  app "macos-mouse-locator-main/.build/MouseLocator.app", target: "~/Applications/MouseLocator.app"
  prefpane "macos-mouse-locator-main/.build/MouseLocator.prefPane"

  preflight_steps do
    run "/usr/bin/xcodebuild", args: ["-version"], print_stdout: true
    inreplace "macos-mouse-locator-main/Makefile", "swift build", "swift build --disable-sandbox"
    run "/usr/bin/make",
        args:         ["app", "prefpane"],
        chdir:        "macos-mouse-locator-main",
        print_stdout: true
  end

  uninstall quit:       "dev.brice.MouseLocator",
            login_item: "Mouse Locator"

  caveats <<~EOS
    Mouse Locator requires Xcode with Swift 6. Select it before installing:
      sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

    Mouse Locator is built from the latest source with an ad-hoc signature and is not notarized.
    If macOS blocks the app, allow it in:
      System Settings → Privacy & Security

    To enable launch at login:
      open -a "Mouse Locator" --args --register-login

    Input Monitoring permission must be granted again after every upgrade
    because source builds are ad-hoc signed.
  EOS
end
