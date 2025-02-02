cp /workspace/.ssh/id_rsa* $HOME/.ssh/
cp /workspace/.gitconfig $HOME/

conda init zsh
chsh -s $(which zsh)
echo "cd /workspace/cuda" >> $HOME/.zshrc
source $HOME/.zshrc
echo "alias ca='conda activate'" >> $HOME/.zshrc
echo "alias cel='conda env list'" >> $HOME/.zshrc
echo "alias concr='conda create'" >> $HOME/.zshrc
echo "ca cuda" >> $HOME/.zshrc
source ~/.zshrc

echo "Git username: " $(git config --global user.name)
echo "Git email: " $(git config --global user.email)

apt-get -y install less
