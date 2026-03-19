class Trustmybot < Formula
  desc "Multi-agent workflow engine for industrial-grade software projects"
  homepage "https://github.com/ZaxShen/TMB"
  url "https://github.com/ZaxShen/TMB/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "6d47124b3b4a6ee3d14184cfa71a7f03ad91cc7e931a9128bfd784322c874ee6"
  license "AGPL-3.0-only"

  depends_on "uv"

  def install
    %w[bot bro tmb].each do |cmd|
      (bin/cmd).write <<~BASH
        #!/bin/bash
        TOOL_BIN="$(uv tool dir --bin 2>/dev/null || echo "$HOME/.local/bin")"
        if [ ! -x "$TOOL_BIN/bro" ]; then
          echo "  Installing trustmybot v#{version}..."
          uv tool install --python 3.13 "trustmybot==#{version}"
        fi
        if [ ! -x "$TOOL_BIN/#{cmd}" ]; then
          echo "Error: trustmybot installation failed. Try manually: uv tool install trustmybot"
          exit 1
        fi
        exec "$TOOL_BIN/#{cmd}" "$@"
      BASH
    end
  end

  def caveats
    <<~EOS
      On first run, trustmybot will be installed via `uv tool install`.
      Run `bro --version` to verify.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bro --version", 0)
  end
end
