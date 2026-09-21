class Rnr < Formula
  desc "Securely file and directory renamer that supports regular expressions"
  homepage "https://github.com/ismaelgv/rnr"
  url "https://github.com/ismaelgv/rnr/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "af35b5d5afab08b01cab345686d7e7d2d37a33d268fa8827a8001c3164ef4722"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "άνθρωποι.txt"
    system("#{bin}/rnr", "to-ascii", "-f", "άνθρωποι.txt")
    assert_path_exists testpath/"anthropoi.txt"
    refute_path_exists testpath/"άνθρωποι.txt"

    # test undo operation
    dump_file = Pathname.glob("rnr-*.json").first
    system("#{bin}/rnr", "from-file", "-f", "-u", dump_file)
    refute_path_exists testpath/"anthropoi.txt"
    assert_path_exists testpath/"άνθρωποι.txt"
  end
end
