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

###
###

# prod
init-new-VMs-part1:
	ansible-playbook -i ./prod.yml update.yml --vault-password-file ./vaultpassw
	ansible-playbook -i ./prod.yml install_common.yml --vault-password-file ./vaultpassw
	
## Install prod-master prod-nodes
init-new-VMs-part2:
	ansible-playbook -i ./prod.yml --vault-password-file ./vaultpassw docker.yml
	ansible-playbook -i ./prod.yml --vault-password-file ./vaultpassw harbor_registry.yml
	
# master - prod
init-new-prod-master:
	ansible-playbook -i prod_master.yml --vault-password-file ./vaultpassw ./k3s_master.yml
	ansible-playbook -i prod_master.yml --vault-password-file ./vaultpassw node.yml 
	ansible-playbook -i prod_master.yml --vault-password-file ./vaultpassw tmux.yml
	ansible-playbook -i prod_master.yml --vault-password-file ./vaultpassw install_rare.yml
	ansible-playbook -i prod_master.yml --vault-password-file ./vaultpassw nvim.yml
	ansible-playbook -i prod_master.yml --vault-password-file ./vaultpassw nvim-sync.yml
	ansible-playbook -i prod_master.yml --vault-password-file ./vaultpassw zsh.yml

	# RUN On Master to mark worker k3s nodes
	kubectl label node matcha node-role.kubernetes.io/worker=worker
	
# nodes - prod 
init-new-prod-nodes:
	ansible-playbook -i ./prod_nodes.yml --extra-vars "env=prod" --vault-password-file ./vaultpassw ./k3s_nodes.yml
	
update-k3s-master:
	ansible-playbook -i prod_master.yml --extra-vars "env=prod" --vault-password-file ./vaultpassw k3s_update_master.yml

update-k3s-nodes:
	ansible-playbook -i prod_nodes.yml --extra-vars "env=prod" --vault-password-file ./vaultpassw k3s_update_nodes.yml

###
###

update-k3s-prod-nodes:
	ansible-playbook -i ./prod_nodes.yml --extra-vars "env=prod" --vault-password-file ./vaultpassw ./k3s_nodes_update_config.yml

update_k3s_config:
	ansible-playbook k3s_nodes_udpate_config.yml --vault-password-file ./vaultpassw
