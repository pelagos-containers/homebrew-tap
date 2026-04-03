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
  version "0.60.1"
  license "Apache-2.0"

  on_linux do
    on_intel do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-x86_64-linux"
      sha256 "f9400ed879ae1df0950686fb1c12b1d5fe820ca348eaafb841dc014cf07fb749"
    end

    on_arm do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-aarch64-linux"
      sha256 "2ccd944d96b90c30d7fc1f6fedf1785fc5f9e3cf9a3b35e788d2f9835d1743e3"
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
