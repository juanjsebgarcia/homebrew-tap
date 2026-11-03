class Loudstation < Formula
  desc "Detect and fix silent monitor speakers on Apple Silicon Macs"
  homepage "https://github.com/juanjsebgarcia/loudstation"
  url "https://github.com/juanjsebgarcia/loudstation/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ecfdfcd48cdc7e44bab5162bfacd5b1268037619042b091adfb9fea1d78f3244"
  license "MIT"

  # The fault and the fix are specific to Apple Silicon's DCP display coprocessors.
  depends_on arch: :arm64
  depends_on macos: :ventura

  def install
    system "make", "all"
    bin.install "build/loudstation"
    libexec.install "build/LoudStation.app"
  end

  def caveats
    <<~EOS
      Start the menu bar app once; from then on it starts at every login:
        loudstation app
      On first run it asks whether to fix your monitor speakers automatically. A fix
      switches that display off and on, so it goes black for about 3 seconds.

      After `brew uninstall` the login item does nothing. To remove it as well:
        launchctl bootout gui/$(id -u)/io.github.juanjsebgarcia.loudstation
        rm ~/Library/LaunchAgents/io.github.juanjsebgarcia.loudstation.plist
    EOS
  end

  test do
    assert_match "loudstation", shell_output("#{bin}/loudstation --version")
    assert_match version.to_s, shell_output("#{bin}/loudstation --version") if build.stable?
    assert_predicate libexec/"LoudStation.app/Contents/MacOS/LoudStation", :executable?
  end
end
