all:
	apertium-validate-dictionary apertium-id-ms.id-ms.dix
	lt-comp lr apertium-id-ms.id-ms.dix id-ms.autobil.bin
	lt-comp rl apertium-id-ms.id-ms.dix ms-id.autobil.bin
	
	apertium-validate-transfer apertium-id-ms.id-ms.t1x
	apertium-preprocess-transfer apertium-id-ms.id-ms.t1x id-ms.t1x.bin

clean:
	rm -f *.bin 

test:
	echo 'Silakan klik tombol "lanjut" untuk meneruskan ke tahap berikutnya' | lt-proc id-ms.automorf.bin | apertium-tagger -g id-ms.prob | apertium-pretransfer | apertium-transfer apertium-id-ms.id-ms.t1x id-ms.t1x.bin id-ms.autobil.bin | lt-proc -g id-ms.autogen.bin

