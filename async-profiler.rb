class AsyncProfiler < Formula
  desc "Sampling CPU & HEAP profiler for Java featuring AsyncGetCallTrace + perf_events"
  homepage "https://github.com/jvm-profiling-tools/async-profiler"
  license "Apache-2.0"
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/async-profiler/async-profiler/releases/download/v4.0/async-profiler-4.0-linux-x64.tar.gz"
      sha256 "ba32bd69cc2906f6251cd5aa8ae72c3abc12267ba858d38733f7751cc4d3e05b"
    elsif Hardware::CPU.arm?
      url "https://github.com/async-profiler/async-profiler/releases/download/v4.0/async-profiler-4.0-linux-arm64.tar.gz"
      sha256 "482c142075dd8eeb762627087dd663725631e2747822f4480753e3b5507b3a62"
    end
  else
    # The macOs distribution works for intel and arm64
    url "https://github.com/async-profiler/async-profiler/releases/download/v4.0/async-profiler-4.0-macos.zip"
    sha256 "1f27e5f5952ec40126a22addad6989bcbeb0509da8a2714ec489953abd698360"
  end

  def install
    ohai "Installing #{HOMEBREW_PREFIX}/bin/asprof"
    bin.install Dir["bin/*"]
    ohai "Installing #{HOMEBREW_PREFIX}/lib/#{shared_library("libasyncProfiler")}"
    lib.install Dir["lib/*"]

    # Neet to codesign the lib ?
    # codesign -v -vvv /opt/homebrew/lib/libasyncProfiler.dylib => not signed
    # libasyncProfiler = shared_library("libasyncProfiler")
    # MachO.codesign!(lib/libasyncProfiler)
  end

  # def post_install
  #   libasyncProfiler = "#{HOMEBREW_PREFIX}/lib/#{shared_library("libasyncProfiler")}"
  #   ohai <<~EOS
  #   Usage:
  #     Adhoc: asprof start -d 10s -o collapsed,flamegraph,svg,flamegraph.svg
  #     JVM agent: -agentpath:#{libasyncProfiler}=start,event=cpu,alloc=2m,lock=10ms,file=profile.jfr
  #     Native: LD_PRELOAD=#{libasyncProfiler} ASPROF_COMMAND=start,event=cpu,file=profile.jfr NativeApp [args]
  #   EOS
  # end

  test do
    output = shell_output("#{bin}/asprof --version")
    assert_match(/Async-profiler 4.0.+/, output.strip)
  end
end
