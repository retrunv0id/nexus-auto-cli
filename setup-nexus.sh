#!/bin/bash

read -p "Masukkan Node ID kamu: " NODE_ID

# Update dan install dependency
sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential pkg-config libssl-dev git-all protobuf-compiler curl screen

# Install Rust jika belum ada
if ! command -v cargo &> /dev/null; then
  echo "🛠️  Rust belum terpasang, memasang sekarang..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
else
  echo "✅ Rust sudah terpasang"
  . "$HOME/.cargo/env"
fi

# Clone & build nexus-cli
rm -rf nexus-cli
git clone https://github.com/nexus-xyz/nexus-cli.git

cd nexus-cli/clients/cli
cargo build --release

# Install binary
sudo cp target/release/nexus-network /usr/local/bin/

# Jalankan dalam screen
cd ~
screen -dmS nexus-node nexus-network start --node-id "$NODE_ID"

# Output petunjuk ke user
echo "✅ Selesai!"
echo "👉 Gunakan perintah berikut untuk melihat log:"
echo "   screen -r nexus-node"
echo "👉 Tekan Ctrl+A lalu D untuk keluar dari screen tanpa menghentikan proses"
