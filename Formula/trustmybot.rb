class Trustmybot < Formula
  desc "Multi-agent workflow engine for industrial-grade software projects"
  homepage "https://github.com/ZaxShen/TMB"
  url "https://github.com/ZaxShen/TMB/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "877267016ee18b519342adfe032a3a7c2d64e96375caf0cac134f148c06127a3"
  license "AGPL-3.0-only"

  depends_on "uv"

  def install
    %w[bot bro tmb].each do |cmd|
      (bin/cmd).write <<~BASH
        #!/bin/bash
        TOOL_BIN="$(uv tool dir --bin 2>/dev/null || echo "$HOME/.local/bin")"
        WANT="#{version}"
        if [ -x "$TOOL_BIN/bro" ]; then
          GOT=$("$TOOL_BIN/bro" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        fi
        if [ "${GOT:-}" != "$WANT" ]; then
          echo "  Installing trustmybot v${WANT}..."
          uv tool install --python 3.13 --force "trustmybot==${WANT}"
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
