# All the credits go to Septina Dian Larasati 
# Modified by Siva Reddy (siva@sivareddy.in) to suit multiple architectures. 

all: 
	echo "If you get segmentation fault, run 'make clean' and run 'make' again"

	if test -e xfst-id.bin; \
	then echo; \
	else cd morphological-analyzer-id-ms && foma -l main-id.foma; \
	fi;
	
	echo "main-id.foma"

	if test -e xfst-ms.bin; \
	then echo; \
	else cd morphological-analyzer-id-ms && foma -l main-ms.foma; \
	fi;
	
	if test -e id-ms.autogen.hfst.ol; \
	then echo; \
	else gzcat xfst-ms.bin | hfst-fst2fst -O -o id-ms.autogen.hfst.ol; \
	fi;

	if test -e ms-id.autogen.hfst.ol; \
	then echo; \
	else gzcat xfst-id.bin | hfst-fst2fst -O -o ms-id.autogen.hfst.ol; \
	fi;

	if test -e id-ms.automorf.hfst.ol; \
	then echo; \
	else gzcat xfst-id.bin | hfst-invert | hfst-fst2fst -O -o id-ms.automorf.hfst.ol; \
	fi; 

	if test -e ms-id.automorf.hfst.ol; \
	then echo; \
	else gzcat xfst-ms.bin | hfst-invert | hfst-fst2fst -O -o ms-id.automorf.hfst.ol; \
	fi;

	apertium-validate-dictionary apertium-id-ms.id-ms.dix
	lt-comp lr apertium-id-ms.id-ms.dix id-ms.autobil.bin
	lt-comp rl apertium-id-ms.id-ms.dix ms-id.autobil.bin
	apertium-validate-transfer apertium-id-ms.id-ms.t1x
	apertium-preprocess-transfer apertium-id-ms.id-ms.t1x id-ms.t1x.bin

modes:
	echo "Use this only if you are planning to use modes. You may have to change your paths in modes/*.mode according to your systempaths"
	apertium-gen-modes modes.xml	

clean:
	rm -f *.bin *.ol 

morphTest:
	echo 'Silakan klik tombol "lanjut" untuk meneruskan ke tahap berikutnya' | hfst-proc id-ms.automorf.hfst.ol

test:
	echo 'Silakan klik tombol "lanjut" untuk meneruskan ke tahap berikutnya' | hfst-proc id-ms.automorf.hfst.ol | apertium-tagger -g id-ms.prob | apertium-pretransfer | apertium-transfer apertium-id-ms.id-ms.t1x id-ms.t1x.bin id-ms.autobil.bin | hfst-proc -g id-ms.autogen.hfst.ol

