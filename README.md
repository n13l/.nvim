# .nvim

ln -s ~/git/.nvim ~/.config/nvim

git clone https://github.com/sourcegraph/amp.nvim.git \
  ~/.local/share/nvim/site/pack/plugins/start/amp.nvim

git clone https://github.com/ibhagwan/fzf-lua.git \
  ~/.local/share/nvim/site/pack/plugins/start/fzf-lua

(nvim-linux-x86_64.tar.gz)
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-arm64.tar.gz
sudo tar -xzf nvim-linux-arm64.tar.gz -C /opt
sudo ln -sf /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim
