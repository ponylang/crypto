config ?= release

BUILD_DIR ?= build/$(config)
SRC_DIR ?= crypto
tests_binary := $(BUILD_DIR)/crypto

ifdef config
	ifeq (,$(filter $(config),debug release))
		$(error Unknown configuration "$(config)")
	endif
endif

ifeq ($(config),release)
	PONYC = ponyc
else
	PONYC = ponyc --debug
endif

SOURCE_FILES := $(shell find $(SRC_DIR) -name \*.pony)

test: unit-tests build-examples

unit-tests: $(tests_binary)
	$^ --exclude=integration --sequential

$(tests_binary): $(GEN_FILES) $(SOURCE_FILES) | $(BUILD_DIR)
	${PONYC} -o ${BUILD_DIR} $(SRC_DIR)

build-examples:
	find examples/*/* -name '*.pony' -print | xargs -n 1 dirname  | sort -u | grep -v ffi- | xargs -n 1 -I {} ponyc  -d -s --checktree -o ${BUILD_DIR} {}

clean:
	rm -rf $(BUILD_DIR)

realclean:
	rm -rf build

TAGS:
	ctags --recurse=yes $(SRC_DIR)

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean realclean TAGS test
