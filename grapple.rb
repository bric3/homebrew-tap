class Grapple < Formula
    desc "Interruptible download accelerator, written in Rust"
    homepage "https://github.com/daveallie/grapple"
    url "https://github.com/daveallie/grapple/archive/v0.3.1.tar.gz"
    sha256 "eda7ca1bc01ee42e63d2ea3d55f4d6ec0d7d66fd6825aad1481d08a38cb64ae7"
  
    depends_on "rust" => :build
  
    def install
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    end
  
    test do
      output = shell_output("#{bin}/grapple --version")
      assert_equal "Grapple #{version}", output.strip
  
      shell_output("#{bin}/grapple -t2 http://i.imgur.com/z4d4kWk.jpg")
      assert_predicate testpath/"z4d4kWk.jpg", :exist?
    end
  end