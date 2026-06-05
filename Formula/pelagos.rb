# pelagos Homebrew formula (Linux only)
#
# Installs the pelagos container runtime binary for Linux (x86_64 and aarch64).
# This formula is Linux-only; macOS users should use pelagos-mac instead.
#
# Usage:
#   brew tap pelagos-containers/tap
#   brew install pelagos-containers/tap/pelagos

class Pelagos < Formula
  desc "Fast Linux container runtime — OCI-compatible, namespaces, cgroups v2, seccomp, networking"
  homepage "https://github.com/pelagos-containers/pelagos"
  version "0.65.27"
  license "Apache-2.0"

  on_linux do
    on_intel do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-x86_64-linux"
      sha256 "e71d51e9542d2298f7ea7799219075b58f31f3173f17c5f0ecc6c48c714165e2"
    end

    on_arm do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-aarch64-linux"
      sha256 "fbb47fe88a49c2d787cbfd6db1a437f90fd4db3cde506d133335dc5e97857bf0"
    end
  end

  def install
    binary = Hardware::CPU.intel? ? "pelagos-x86_64-linux" : "pelagos-aarch64-linux"
    bin.install binary => "pelagos"
  end

  def caveats
    <<~EOS
      pelagos requires nftables and iproute2. Install them via your system package manager:
        sudo apt-get install -y nftables iproute2    # Debian/Ubuntu
        sudo dnf install -y nftables iproute2        # Fedora/RHEL

      Run the setup script once to initialise the image store and pelagos group:
        sudo pelagos system setup

      Then add yourself to the pelagos group:
        sudo usermod -aG pelagos $USER
      Log out and back in (or run 'newgrp pelagos') for the change to take effect.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pelagos --version 2>&1")
  end
end
