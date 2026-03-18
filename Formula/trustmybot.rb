class Trustmybot < Formula
  desc "Multi-agent workflow engine for industrial-grade software projects"
  homepage "https://github.com/ZaxShen/TMB"
  url "https://github.com/ZaxShen/TMB/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c174fb8df2a8afad6fdb67dc3df36c14c84da6b87901a95add17943d6ed126e4"
  license "AGPL-3.0-only"

  depends_on "uv"

  def install
    # Install trustmybot into a dedicated venv managed by Homebrew
    venv = libexec/"venv"
    system "uv", "venv", "--python", "3.13", venv.to_s
    system venv/"bin/pip", "install", "trustmybot==#{version}"

    # Create wrapper scripts that use the venv's Python
    %w[bot bro tmb].each do |cmd|
      (bin/cmd).write <<~BASH
        #!/bin/bash
        exec "#{venv}/bin/#{cmd}" "$@"
      BASH
    end
  end

  test do
    assert_match "Trust Me Bro", shell_output("#{bin}/bro --version")
  end
end
