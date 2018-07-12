PWD := $(shell pwd)
SCP := $(shell which scp)
SED := $(shell which sed)
VER := $(shell cat ./Version)
FS  := username@file.server.address:~/path.in.home

.PHONY: proto compile        shell test	    console-dev		rel-dev rel-stage rel-prod

all: proto compile

proto:
	$(PWD)/script/gpb -pkgs 	-I $(PWD)/proto 	-o-erl $(PWD)/src 	-o-hrl $(PWD)/include 	$(PWD)/proto/*.proto

compile:
	$(PWD)/script/rebar3 compile

shell:
	$(PWD)/script/rebar3 shell

test:
	$(PWD)/script/rebar3 ct

console-dev:
	_build/dev/rel/distributed_storage/bin/distributed_storage console

rel-prod:
	$(SED) -i 's/{distributed_storage, "distributed_storage-version"}/{distributed_storage, "$(VER)"}/g' ./rebar.config
	$(PWD)/script/rebar3 as prod release
	$(PWD)/script/rebar3 as prod tar
	$(SED) -i 's/{distributed_storage, "$(VER)"}/{distributed_storage, "distributed_storage-version"}/g' ./rebar.config
    #$(SCP) -P 8522 $(PWD)/_build/prod/rel/distributed_storage/distributed_storage-$(VER).tar.gz $(FS)
	@printf "\nApplication: %s\n" $(PWD)/_build/prod/rel/distributed_storage/distributed_storage-$(VER).tar.gz

rel-stage:
	$(SED) -i 's/{distributed_storage, "distributed_storage-version"}/{distributed_storage, "$(VER)"}/g' ./rebar.config
	$(PWD)/script/rebar3 as stage release
	$(PWD)/script/rebar3 as stage tar
	$(SED) -i 's/{distributed_storage, "$(VER)"}/{distributed_storage, "distributed_storage-version"}/g' ./rebar.config
    #$(SCP) -P 8522 $(PWD)/_build/stage/rel/distributed_storage/distributed_storage-$(VER).tar.gz $(FS)
	@printf "\nApplication: %s\n" $(PWD)/_build/stage/rel/distributed_storage/distributed_storage-$(VER).tar.gz

rel-dev:
	$(PWD)/script/rebar3 as dev release

