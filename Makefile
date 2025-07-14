.PHONY: build

build:
	cargo build
	cp target/debug/caro ./caro

clean:
	rm caro
	cargo clean
