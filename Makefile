SHELL:=$(or $(CONFIG_SHELL),bash)
BSB := ./node_modules/.bin/bsb.exe
BSB_ARGS:= -make-world
SOURCE_DIRS_JSON := lib/bs/.sourcedirs.json

all: serve

serve:
	trap 'kill %1' INT TERM
	# BuckleScript doesn't like being run first.
	yarn serve & $(MAKE) watch

$(SOURCE_DIRS_JSON): bsconfig.json
	$(BSB) -install

bs:
	$(BSB) $(BSB_ARGS)

watch: $(SOURCE_DIRS_JSON)
	# `entr` exits when the directory changes, so we restart it to pick up
	# updated files
	while true; do \
		trap 'break' INT; \
		find -L $$(jq -r 'include "./dirs"; dirs' $(SOURCE_DIRS_JSON)) -maxdepth 1 \
			-type f -iregex ".*\.\(re\|ml\)i?" | \
		entr -nd $(BSB) $(BSB_ARGS); \
	done

print-%: ; @echo $*=$($*)

clean:
	$(BSB) -clean-world

.PHONY: bs bsdirs all clean
