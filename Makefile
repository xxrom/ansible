init-everything:
	ansible-playbook install_common.yml --vault-password-file ./vaultpassw
	ansible-playbook node.yml --vault-password-file ./vaultpassw
	ansible-playbook tmux.yml --vault-password-file ./vaultpassw
	ansible-playbook zsh.yml --vault-password-file ./vaultpassw
	ansible-playbook k3s_master.yml --vault-password-file ./vaultpassw
	ansible-playbook k3s_nodes.yml --vault-password-file ./vaultpassw
	ansible-playbook nvim.yml --vault-password-file ./vaultpassw
	ansible-playbook nvim-sync.yml --vault-password-file ./vaultpassw
	ansible-playbook docker.yml --vault-password-file ./vaultpassw
