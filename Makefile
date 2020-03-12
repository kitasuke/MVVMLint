.PHONY: build build_release install clean

EXECUTABLE_NAME = MVVMLint
BIN_DIR = /usr/local/bin
DEBUG_DIR = .build/debug
RELEASE_DIR = .build/release
RELEASE_BUILD_FLAGS= -c release --disable-sandbox

build:
	@swift build
	@mv $(DEBUG_DIR)/$(EXECUTABLE_NAME) $(DEBUG_DIR)/mvvmlint

build_release:
	@swift build $(RELEASE_BUILD_FLAGS)
	@mv $(RELEASE_DIR)/$(EXECUTABLE_NAME) $(RELEASE_DIR)/mvvmlint

install: build_release
	@install -d "$(BIN_DIR)"
	@install "$(RELEASE_DIR)/mvvmlint" "$(BIN_DIR)"
	@cd $(RELEASE_DIR) && zip mvvmlint.zip mvvmlint

clean:
	@rm -rf .build
