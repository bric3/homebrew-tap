class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java featuring AsyncGetCallTrace + perf_events"
  homepage "https://github.com/jvm-profiling-tools/async-profiler"
  license "Apache-2.0"
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.8/async-profiler-2.8-linux-x64.tar.gz"
      sha256 "f3a52b167cfd59f740383c57cd9c6da5b0b4d8b0efb7d01510b2af1e0cd5472e"
    elsif Hardware::CPU.arm?
      url "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.8/async-profiler-2.8-linux-arm64.tar.gz"
      sha256 "7b9e9f4516ca5036834c911bed84e8a67b0ddeeb4ad839fb4fd282fc8b13fd05"
    end
  else
    # The macOs distribution works for intel and arm64
    url "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.8/async-profiler-2.8-macos.zip"
    sha256 "d5bf9758f479e7873e81c61c9cff376bd82202aa56028f851f497b508f177b1e"
  end

  # don't download openjdk, it may have been installed by other means 
  # depends_on "openjdk"

  # Fix script location (make the diff with 'diff -u orignal/profiler.sh pathed/profiler.sh')
  patch :p0, :DATA

  def install
    # bin.install Dir["*"]

    libexec.install Dir["*"]
    # libexec.install_symlink "#{libexec}/profiler.sh" => "profiler.sh"
    bin.install_symlink "#{libexec}/profiler.sh"
  end

  def post_install
    if OS.mac?
      # Using the .so extension for the library file because async-profiler builds
      # the macOs library with the .so extension, hence the dylib symlink in the same directory
      Dir["#{libexec}/build/*.so"].each do |dylib|
        chmod 0664, dylib
        # id found with otool -L async-profiler-2.8-macos/build/libasyncProfiler.so
        MachO::Tools.change_dylib_id(dylib, "build/#{File.basename(dylib)}")
        chmod 0444, dylib
      end
    end
  end

  # Tests disabled because the test environment doesn't find java
  # test do
  #   output = shell_output("#{bin}/profiler.sh --version")
  #   assert_match(/Async-profiler 2.8.+/, output.strip)
  # end

  def caveats
    <<~EOS
      To use async-profiler, you need to install a JVM.
    EOS
  end
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
+FDTRANSFER=$SCRIPT_DIR/../libexec/build/fdtransfer
 USE_FDTRANSFER="false"
-PROFILER=$SCRIPT_DIR/build/libasyncProfiler.so
+PROFILER=$SCRIPT_DIR/../libexec/build/libasyncProfiler.so
 ACTION="collect"
 DURATION="60"
 FILE=""
