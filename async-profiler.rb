class AsyncProfiler < Formula
  desc "Sampling CPU and HEAP profiler for Java featuring AsyncGetCallTrace + perf_events"
  homepage "https://github.com/jvm-profiling-tools/async-profiler"
  url "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.8/async-profiler-2.8-macos.zip"
  sha256 "d5bf9758f479e7873e81c61c9cff376bd82202aa56028f851f497b508f177b1e"
  license "Apache-2.0"

  # Fix script location (make the diff with 'diff -u orignal/profiler.sh pathed/profiler.sh')
  patch :p0, :DATA

  def install
    # bin.install Dir["*"]

    libexec.install Dir["*"]
    # libexec.install_symlink "#{libexec}/profiler.sh" => "profiler.sh"
    bin.install_symlink "#{libexec}/profiler.sh"
  end

  # test do
  #   output = shell_output("#{bin}/profiler.sh --version")
  #   assert_match(/Async-profiler 2.8.+/, output.strip)
  # end
end

__END__
--- profiler.sh	2022-05-09 21:59:25.000000000 +0200
+++ profiler.sh	2022-05-17 15:31:21.000000000 +0200
@@ -125,12 +125,12 @@
 while [ -h "$SCRIPT_BIN" ]; do
     SCRIPT_BIN="$(readlink "$SCRIPT_BIN")"
 done
-SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_BIN")" > /dev/null 2>&1; pwd -P)"
+SCRIPT_DIR="$(cd -- "$(dirname "$0")"; cd -- "$(dirname "$SCRIPT_BIN")" > /dev/null 2>&1; pwd -P)"
 
-JATTACH=$SCRIPT_DIR/build/jattach
-FDTRANSFER=$SCRIPT_DIR/build/fdtransfer
+JATTACH=$SCRIPT_DIR/../libexec/build/jattach
+FDTRANSFER=$SCRIPT_DIR/../libexec//build/fdtransfer
 USE_FDTRANSFER="false"
-PROFILER=$SCRIPT_DIR/build/libasyncProfiler.so
+PROFILER=$SCRIPT_DIR/../libexec/build/libasyncProfiler.so
 ACTION="collect"
 DURATION="60"
 FILE=""
