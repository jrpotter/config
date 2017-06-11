for file in .env .aliases; do
  if [ -f ~/$file ]; then
    source ~/$file
  fi
done

if type powerline-daemon >/dev/null; then
  powerline-daemon -q
  if [ -r $POWERLINE/bindings/zsh/powerline.zsh ]; then
    source $POWERLINE/bindings/zsh/powerline.zsh
  fi
fi
