DOT=${HOME}/.dotfiles
STOW=./stow.sh

all:
	${STOW} --verbose --restow --target="${HOME}" --dir="${DOT}" */

clean:
	${STOW} --verbose --target="${HOME}" --delete */
