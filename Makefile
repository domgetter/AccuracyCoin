all: nesos.nes edn8/255/output_files/255.RBF

# Create the test suite rom from source
# Also, since nesasm doesn't return non-zero on failure, copy the output
#   to a separate file, check if there are any errors, and if so, break out of the build
# You can read the output by opening/catting the build.log file
AccuracyCoin.nes: AccuracyCoin.asm Sprites.pcx Tiles.pcx
	./nesasm.exe AccuracyCoin.asm 2>&1 | tee build.log | grep -q "error" && exit 1 || true

.PHONY: everdrive all

# Extract just the 32k PRG
AccuracyCoin.prg: AccuracyCoin.nes
	head -c 32784 AccuracyCoin.nes | tail -c 32768 > AccuracyCoin.prg

# Patch the 32k PRG onto a template version of the os rom that is already the right size
# and already includes the graphics of AccuracyCoin.nes
# TODO: update the CHR on rebuild as well
nesos.nes: AccuracyCoin.prg nesos_template.nes
	cp nesos_template.nes nesos.nes
	dd if=AccuracyCoin.prg of=nesos.nes bs=1 seek=98320 conv=notrunc

# Copy the new nesos.nes and mapper file to the N8 Pro
# THIS OVERWRITES THE CURRENT OS AND ITS MAPPER!!!!!
everdrive: all
	edlink-n8 -cp nesos.nes sd:/EDN8/
	edlink-n8 -cp edn8/255/output_files/255.RBF sd:/EDN8/maps/

# Recursive make to build the mapper
.PHONY: edn8/255/output_files/255.RBF
edn8/255/output_files/255.RBF:
	$(MAKE) -C edn8/255