output_files/000.RBF: output_files/top.rbf
	@cp output_files/top.rbf output_files/000.RBF

output_files/top.rbf: map_000.sv map_hub.sv top.qpf top.qsf $(wildcard ../base_sv/*)
	@echo -e "\t Analysis & Synthesis"
	@quartus_map --read_settings_files=on --write_settings_files=off top -c top >quartus_output.txt
	@echo -e "\t Fitter (Place & Route)"
	@quartus_fit --read_settings_files=off --write_settings_files=off top -c top >>quartus_output.txt
	@echo -e "\t Assembler (Generate programming files)"
	@quartus_asm --read_settings_files=off --write_settings_files=off top -c top >>quartus_output.txt

.PHONY: everdrive clean

clean:
	rm output_files/top.rbf

error:
	@grep --color=auto Error quartus_output.txt

everdrive: output_files/000.RBF
	@echo -e "\t Copying to Everdrive N8 Pro"
	@edlink-n8 -cp output_files/000.RBF sd:/EDN8/maps/