class Thesystem < Formula
  desc      "Install it and you have a dev shop"
  homepage  "https://github.com/tjamescouch/TheSystem"
  license   "MIT"
  version   "0.2.3"

  url "https://github.com/tjamescouch/TheSystem/releases/download/v0.2.3/thesystem-0.2.3.tar.gz"
  sha256 "79f7d71aba5153406812a64994ead5cca5a2530d8406b86b149dac16609427b3"

  depends_on "lima"
  depends_on "node"

  def install
    libexec.install Dir["dist/*"]
    libexec.install "lima"
    libexec.install "package.json"

    # Ensure entry point is executable
    chmod 0755, libexec/"cli.js"

    # Install node_modules in libexec
    cd libexec do
      system "npm", "install", "--omit=dev", "--no-package-lock"
    end

    (bin/"thesystem").write_env_script libexec/"cli.js", {
      PATH: "#{Formula["node"].opt_bin}:#{HOMEBREW_PREFIX}/bin:#{ENV["PATH"]}",
      THESYSTEM_LIMA_TEMPLATE: "#{libexec}/lima/thesystem.yaml",
    }
  end

  test do
    system "#{bin}/thesystem", "version"
  end
end
