BSB := ./node_modules/.bin/bsb.exe
BSB_ARGS:= -make-world

all: serve

serve:
	trap 'kill %1' SIGINT
	# BuckleScript doesn't like being run first.
	yarn serve & $(MAKE) watch

bs:
	$(BSB) $(BSB_ARGS)

# Purposely not `:=` (strict) because we want it to be executed everytime
BSDIRS = $(shell find -L $$(jq -r 'include "./dirs"; dirs' ./lib/bs/.sourcedirs.json) -maxdepth 1 -type f -iregex ".*\.\(re\|ml\)i?")

watch: bs
	printf "%s\n" $(BSDIRS) | entr -d -s '$(BSB) $(BSB_ARGS)'

print-%: ; @echo $*=$($*)

clean:
	$(BSB) -clean-world

.PHONY: bs bsdirs all clean
