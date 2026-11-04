# SPDX-License-Identifier: MPL-2.0

class GlowAdoc < Formula
  desc "Read AsciiDoc in the terminal"
  homepage "https://github.com/bric3/glow-adoc"
  url "https://github.com/bric3/glow-adoc/releases/download/v0.2.0/glow-adoc-0.2.0.zip"
  sha256 "51d4dee3afd39f25bc7375154dcba440cf7bc523008b7d667d3fc8e0699e123b"
  license "MPL-2.0"

  depends_on "openjdk@27"
  # Mermaid diagrams additionally use an optional `brew install merman-cli`.

  def install
    libexec.install "bin", "lib"
    (bin/"glow-adoc").write <<~SH
      #!/bin/sh
      export JAVA_HOME="#{Language::Java.java_home("27")}"
      export PATH="$JAVA_HOME/bin:$PATH"
      exec "#{libexec}/bin/glow-adoc" "$@"
    SH
    (bin/"glow-adoc").chmod 0755
  end

  test do
    assert_equal "glow-adoc #{version}\n", shell_output("#{bin}/glow-adoc --version")
    (testpath/"sample.adoc").write "= Hello\n\nA *bold* sentence.\n"
    assert_match "A bold sentence.", shell_output("#{bin}/glow-adoc --no-pager --no-cache --color=never sample.adoc")
  end
end
