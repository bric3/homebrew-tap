class AsyncProfiler < Formula
  desc "Sampling CPU and HEAP profiler for Java featuring AsyncGetCallTrace + perf_events"
  homepage "https://github.com/jvm-profiling-tools/async-profiler"
  url "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.5.1/async-profiler-2.5.1-macos.zip"
  sha256 "ebd7409f15fa579e91fb1ef1263d285e526b2e87c3f0354975c2477889db6f02"
  license "Apache-2.0"

  # Fix script location
  patch :p0, :DATA

  def install
    # bin.install Dir["*"]

    libexec.install Dir["*"]
    # libexec.install_symlink "#{libexec}/profiler.sh" => "profiler.sh"
    bin.install_symlink "#{libexec}/profiler.sh"
  end

  # test do
  #   output = shell_output("#{bin}/profiler.sh --version")
  #   assert_match(/Async-profiler 2.5.1.+/, output.strip)
  # end
end

__END__
--- profiler.sh	2021-12-07 01:10:43.000000000 +0100
+++ profiler.sh	2022-01-04 10:51:04.000000000 +0100
@@ -124,7 +124,7 @@
 while [ -h "$SCRIPT_BIN" ]; do
     SCRIPT_BIN="$(readlink "$SCRIPT_BIN")"
 done
-SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_BIN")" > /dev/null 2>&1; pwd -P)"
+SCRIPT_DIR="$(cd -- "$(dirname "$0")"; cd -- "$(dirname "$SCRIPT_BIN")" > /dev/null 2>&1; pwd -P)"

 JATTACH=$SCRIPT_DIR/build/jattach
 FDTRANSFER=$SCRIPT_DIR/build/fdtransfer
