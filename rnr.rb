class Rnr < Formula
  desc "Securely file and directory renamer that supports regular expressions"
  homepage "https://github.com/ismaelgv/rnr"
  url "https://github.com/ismaelgv/rnr/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "db0be923ed8a35c188934f636f536be0b3d5384c598fab22da3d66b5a69d9398"
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
