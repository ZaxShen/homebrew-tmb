class Trustmybot < Formula
  desc "Multi-agent workflow engine for industrial-grade software projects"
  homepage "https://github.com/ZaxShen/TMB"
  url "https://github.com/ZaxShen/TMB/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c174fb8df2a8afad6fdb67dc3df36c14c84da6b87901a95add17943d6ed126e4"
  license "AGPL-3.0-only"

  depends_on "uv"

  def install
    # Create wrapper scripts that install on first run via uv tool
    %w[bot bro tmb].each do |cmd|
      (bin/cmd).write <<~BASH
        #!/bin/bash
        # Ensure trustmybot is installed via uv tool
        if ! command -v "$(uv tool dir --bin 2>/dev/null)/bro" >/dev/null 2>&1; then
          echo "  Installing trustmybot v#{version}..."
          uv tool install "trustmybot==#{version}" >/dev/null 2>&1
        fi
        exec "$(uv tool dir --bin 2>/dev/null)/#{cmd}" "$@"
      BASH
    end
  end

  def caveats
    <<~EOS
      trustmybot is managed by uv. On first run, it will install
      into uv's tool directory. Run `bro --version` to verify.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bro --version", 0)
  end
end
