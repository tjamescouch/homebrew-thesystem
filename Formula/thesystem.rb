class Thesystem < Formula
  desc      "Install it and you have a dev shop"
  homepage  "https://github.com/tjamescouch/TheSystem"
  license   "MIT"
  version   "0.2.13"

  url "https://github.com/tjamescouch/TheSystem/releases/download/v0.2.13/thesystem-0.2.13.tar.gz"
  sha256 "d7bceeec123c817ab6181a87a552510ef822bb5ad4a4f4e68274b7415a37f51a"

  depends_on "lima"
  depends_on "node"

  def install
    libexec.install Dir["dist/*"]
    libexec.install "lima"
    libexec.install "package.json"

    # Ensure entry point and biometric helper are executable
    chmod 0755, libexec/"cli.js"
    chmod 0755, libexec/"thesystem-keychain" if (libexec/"thesystem-keychain").exist?

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
