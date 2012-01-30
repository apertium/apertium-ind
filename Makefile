# All the credits go to Septina Dian Larasati 
# Modified by Siva Reddy (siva@sivareddy.in) to suit multiple architectures. 

all: xfst-id.bin xfst-ms.bin id-ms.automorf.hfst.ol ms-id.automorf.hfst.ol id-ms.autogen.hfst.ol ms-id.autogen.hfst.ol
	echo "If you get segmentation fault, run 'make clean' and run 'make' again"
	apertium-validate-dictionary apertium-id-ms.id-ms.dix
	lt-comp lr apertium-id-ms.id-ms.dix id-ms.autobil.bin
	lt-comp rl apertium-id-ms.id-ms.dix ms-id.autobil.bin
	apertium-validate-transfer apertium-id-ms.id-ms.t1x
	apertium-preprocess-transfer apertium-id-ms.id-ms.t1x id-ms.t1x.bin

modes:
	echo "Use this only if you are planning to use modes. You may have to change your paths in modes/*.mode according to your systempaths"
	apertium-gen-modes modes.xml	

id-ms.automorf.hfst.ol: xfst-id.bin
	echo "Creating id-ms.automorf.hfst.ol"
	zcat xfst-id.bin | hfst-invert | hfst-fst2fst -O -o id-ms.automorf.hfst.ol

ms-id.automorf.hfst.ol: xfst-ms.bin
	echo "Creating ms-id.automorf.hfst.ol"
	zcat xfst-ms.bin | hfst-invert | hfst-fst2fst -O -o ms-id.automorf.hfst.ol

id-ms.autogen.hfst.ol: xfst-ms.bin
	echo "Creating id-ms.autogen.hfst.ol"
	zcat xfst-ms.bin | hfst-fst2fst -O -o id-ms.autogen.hfst.ol	

ms-id.autogen.hfst.ol: xfst-id.bin
	echo "Creating ms-id.autogen.hfst.ol"
	zcat xfst-id.bin | hfst-fst2fst -O -o ms-id.autogen.hfst.ol

xfst-id.bin: 
	cd morphological-analyzer-id-ms && foma -l main-id.foma

xfst-ms.bin:
	cd morphological-analyzer-id-ms && foma -l main-ms.foma

clean:
	rm -f *.bin *.ol 

morphTest:
	echo 'Silakan klik tombol "lanjut" untuk meneruskan ke tahap berikutnya' | hfst-proc id-ms.automorf.hfst.ol

test:
	echo 'Silakan klik tombol "lanjut" untuk meneruskan ke tahap berikutnya' | hfst-proc id-ms.automorf.hfst.ol | apertium-tagger -g id-ms.prob | apertium-pretransfer | apertium-transfer apertium-id-ms.id-ms.t1x id-ms.t1x.bin id-ms.autobil.bin | hfst-proc -g id-ms.autogen.hfst.ol

