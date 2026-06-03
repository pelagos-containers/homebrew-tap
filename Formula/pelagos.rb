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
  version "0.65.22"
  license "Apache-2.0"

  on_linux do
    on_intel do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-x86_64-linux"
      sha256 "7e7a9f9d0997057adda07b44d5eb184629f63ef7d26b7502f2dd943c95a29e60"
    end

    on_arm do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-aarch64-linux"
      sha256 "e3b8ee6f3520f9abb9c411e9e74c5ec5cbfe5dc812243d694afd2268b0444559"
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
