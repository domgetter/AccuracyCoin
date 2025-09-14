all: AccuracyCoinN8Pro.nes edn8/000/output_files/000.RBF

# Create the test suite rom from source
# Also, since nesasm doesn't return non-zero on failure, copy the output
#   to a separate file, check if there are any errors, and if so, break out of the build
# You can read the output by opening/catting the build.log file
AccuracyCoin.nes: AccuracyCoin.asm Sprites.pcx Tiles.pcx
	./nesasm.exe AccuracyCoin.asm 2>&1 | tee build.log | grep -q "error" && exit 1 || true

.PHONY: everdrive all

AccuracyCoinN8Pro.nes: AccuracyCoin.nes
	cp AccuracyCoin.nes AccuracyCoinN8Pro.nes

# Copy AccuracyCoinN8Pro.nes and mapper file to the N8 Pro
everdrive: all
	edlink-n8 -mkdir sd:/accuracy_coin_n8_pro
	edlink-n8 -cp AccuracyCoinN8Pro.nes sd:/accuracy_coin_n8_pro/
	edlink-n8 -cp edn8/000/output_files/000.RBF sd:/accuracy_coin_n8_pro/

# Recursive make to build the mapper
.PHONY: edn8/000/output_files/000.RBF
edn8/000/output_files/000.RBF:
	$(MAKE) -C edn8/000