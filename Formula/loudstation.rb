class Loudstation < Formula
  desc "Fix silent HDMI/DisplayPort monitor audio on Apple Silicon Macs"
  homepage "https://github.com/juanjsebgarcia/loudstation"
  url "https://github.com/juanjsebgarcia/loudstation/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9003a5715b375030fa0b713ddfe2b5987d2eb8e69634a087c3083df5d3c4282e"
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

      After `brew upgrade`, run `loudstation app` again to switch to the new version.

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
