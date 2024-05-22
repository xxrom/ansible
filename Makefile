init-everything:
	ansible-playbook install_common.yml --vault-password-file ./vaultpassw
	ansible-playbook install_rare.yml --vault-password-file ./vaultpassw
	ansible-playbook node.yml --vault-password-file ./vaultpassw
	ansible-playbook tmux.yml --vault-password-file ./vaultpassw
	ansible-playbook zsh.yml --vault-password-file ./vaultpassw
	ansible-playbook k3s_master.yml --vault-password-file ./vaultpassw
	ansible-playbook k3s_nodes.yml --vault-password-file ./vaultpassw
	ansible-playbook nvim.yml --vault-password-file ./vaultpassw
	# run $ sh ./sh/nvim-sync.sh
	ansible-playbook nvim-sync.yml --vault-password-file ./vaultpassw
	ansible-playbook docker.yml --vault-password-file ./vaultpassw
	ansible-playbook harbor_install.yml --vault-password-file ./vaultpassw # Open harbor: admin - Harbor12345 / change password
	ansible-playbook harbor_registry.yml --vault-password-file ./vaultpassw


update_k3s_config:
	ansible-playbook k3s_nodes_udpate_config.yml --vault-password-file ./vaultpassw
