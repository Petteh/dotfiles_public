DOT=${HOME}/.dotfiles
STOW=./stow.sh

all: adopt

adopt:
	${STOW} --verbose --adopt --target="${HOME}" --dir="${DOT}" */

stow:
	${STOW} --verbose --stow --target="${HOME}" --dir="${DOT}" */

restow:
	${STOW} --verbose --restow --target="${HOME}" --dir="${DOT}" */

clean:
	${STOW} --verbose --target="${HOME}" --delete */
