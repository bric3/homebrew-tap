class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java featuring AsyncGetCallTrace + perf_events"
  homepage "https://github.com/jvm-profiling-tools/async-profiler"
  license "Apache-2.0"
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.9/async-profiler-2.9-linux-x64.tar.gz"
      sha256 "b9a094bc480f233f72141b7793c098800054438e0e6cfe5b7f2fe13ef4ad11f0"
    elsif Hardware::CPU.arm?
      url "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.8.3/async-profiler-2.9-linux-arm64.tar.gz"
      sha256 "00c91439b2fc95fa518e47570c451d92c8670c0cd68d908ee53397bb35a42779"
    end
  else
    # The macOs distribution works for intel and arm64
    url "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v2.8.3/async-profiler-2.9-macos.zip"
    sha256 "7f46398aef41561e77012ecbd07d3cc17eac775c03e895df4fcc174f8af2ecc2"
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
