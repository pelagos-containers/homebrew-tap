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
  version "0.65.30"
  license "Apache-2.0"

  on_linux do
    on_intel do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-x86_64-linux"
      sha256 "b4f9ce005ae7386b980cb94bd30fc23d6d59af0755b5fed0c22d12a6b9a11437"
    end

    on_arm do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-aarch64-linux"
      sha256 "0e599ac45d0704e6ee23dfe2e9aa66d295a241f6c92c754711ffd74de3bbdd20"
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
