class Speedsentry < Formula
  desc "Menu bar download speed monitor with alerts and IST incident history"
  homepage "https://github.com/keshavbhardwaz/speedsentry"
  url "https://github.com/keshavbhardwaz/speedsentry/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3fba832bcaf1c9905b43bb8f58c4ba094a3cd1dc59ff6a71eb91f166bcebff30"
  license "MIT"

  depends_on macos: :ventura
  uses_from_macos "swift" => :build

  def install
    swift_version = Utils.safe_popen_read("xcrun", "swift", "--version")[/Swift version (\d+\.\d+)/, 1]
    if swift_version.nil? || Version.new(swift_version) < Version.new("5.9")
      odie "Swift 5.9+ is required. Install current Xcode Command Line Tools with xcode-select --install."
    end

    ENV["VERSION"] = version.to_s
    ENV["CLANG_MODULE_CACHE_PATH"] = (buildpath/".build/clang-module-cache").to_s
    # This dependency-free app compiles directly, bypassing SwiftPM manifest evaluation.
    system "bash", "./scripts/build-app.sh"
    prefix.install "dist/SpeedSentry.app"
    (bin/"speedsentry").write <<~SH
      #!/bin/sh
      exec /usr/bin/open "#{opt_prefix}/SpeedSentry.app" --args "$@"
    SH
    chmod 0755, bin/"speedsentry"
  end

  def caveats
    <<~EOS
      Start the menu bar app with: speedsentry
      This formula compiles locally with an ad hoc signature; no Apple Developer ID is required.
      The app stays in Homebrew's Cellar and opens through its stable opt path.
      Disable Launch at Login before upgrading or uninstalling, then enable it again if needed.
      Check macOS Notifications settings if alerts are missing.
      Uninstalling keeps history at ~/Library/Application Support/SpeedSentry.
    EOS
  end

  test do
    assert_path_exists prefix/"SpeedSentry.app/Contents/MacOS/SpeedSentry"
    assert_match "app.speedsentry.mac", shell_output("/usr/bin/plutil -extract CFBundleIdentifier raw '#{prefix}/SpeedSentry.app/Contents/Info.plist'")
    system "/usr/bin/codesign", "--verify", "--strict", prefix/"SpeedSentry.app"
    assert_match "#{opt_prefix}/SpeedSentry.app", (bin/"speedsentry").read
  end
end
