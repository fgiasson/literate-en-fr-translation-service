.PHONY: build prepare

build:
	nbdev_export
	docker build -t localbuild:en_fr_translation_service .

prepare:
	nbdev_export
	nbdev_readme
	nbdev_clean
