# Add this to your $HOME/.bashrc (or wherever your aliases live)
alias esp32='docker run -i -t --rm -v $HOME:$HOME -w $PWD --device /dev/ttyUSB0 esp32-devel'
