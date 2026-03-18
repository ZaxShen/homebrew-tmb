class Trustmybot < Formula
  include Language::Python::Virtualenv

  desc "Multi-agent workflow engine for industrial-grade software projects"
  homepage "https://github.com/ZaxShen/TMB"
  url "https://files.pythonhosted.org/packages/f1/08/e791964af6b3d2f86a7a9401889b454b1e2c5e5b94b2f3d7e38aebc8a60d/trustmybot-0.5.3.tar.gz"
  sha256 "0773507693fc0f2654c562f421902c564902e14e2fa2ebe0bb2cf3a16038722b"
  license "AGPL-3.0-only"

  depends_on "python@3.13"

  def install
    virtualenv_create(libexec, "python3.13")
    system libexec/"bin/pip", "install", "trustmybot==#{version}"
    bin.install_symlink libexec/"bin/bot"
    bin.install_symlink libexec/"bin/bro"
    bin.install_symlink libexec/"bin/tmb"
  end

  test do
    assert_match "Trust Me Bro", shell_output("#{bin}/bro --version")
  end
end
