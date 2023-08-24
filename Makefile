.PHONY: build

build:
	nbdev_export
	docker build -t localbuild:en_fr_translation_service .
