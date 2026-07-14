# MinUI for TrimUI Smart Pro

# NOTE: this runs on the host system (eg. macOS) not in a docker image

###########################################################

BUILD_HASH:=$(shell git rev-parse --short HEAD)
RELEASE_TIME:=$(shell TZ=GMT date +%Y%m%d)
RELEASE_BASE=MinUI-$(RELEASE_TIME)
RELEASE_DOT:=$(shell find ./releases/. -maxdepth 1 -name '$(RELEASE_BASE)-*-base.zip' 2>/dev/null | wc -l | sed 's/ //g')
RELEASE_NAME=$(RELEASE_BASE)-$(RELEASE_DOT)

PLATFORM=trimuismart

###########################################################

.PHONY: build

export MAKEFLAGS=--no-print-directory

all: setup special package done

name:
	@echo $(RELEASE_NAME)

build:
	make build -f makefile.toolchain PLATFORM=$(PLATFORM)

system:
	make -f ./workspace/$(PLATFORM)/platform/makefile.copy PLATFORM=$(PLATFORM)

	# populate system
	cp ./workspace/$(PLATFORM)/keymon/keymon.elf ./build/SYSTEM/$(PLATFORM)/bin/
	cp ./workspace/$(PLATFORM)/libmsettings/libmsettings.so ./build/SYSTEM/$(PLATFORM)/lib
	cp ./workspace/all/minui/build/$(PLATFORM)/minui.elf ./build/SYSTEM/$(PLATFORM)/bin/
	cp ./workspace/all/minarch/build/$(PLATFORM)/minarch.elf ./build/SYSTEM/$(PLATFORM)/bin/
	cp ./workspace/all/syncsettings/build/$(PLATFORM)/syncsettings.elf ./build/SYSTEM/$(PLATFORM)/bin/
	cp ./workspace/all/say/build/$(PLATFORM)/say.elf ./build/SYSTEM/$(PLATFORM)/bin/
	cp ./workspace/all/clock/build/$(PLATFORM)/clock.elf ./build/EXTRAS/Tools/$(PLATFORM)/Clock.pak/
	cp ./workspace/all/minput/build/$(PLATFORM)/minput.elf ./build/EXTRAS/Tools/$(PLATFORM)/Input.pak/

cores:
	# stock cores
	cp ./workspace/$(PLATFORM)/cores/output/fceumm_libretro.so ./build/SYSTEM/$(PLATFORM)/cores
	cp ./workspace/$(PLATFORM)/cores/output/gambatte_libretro.so ./build/SYSTEM/$(PLATFORM)/cores
	cp ./workspace/$(PLATFORM)/cores/output/gpsp_libretro.so ./build/SYSTEM/$(PLATFORM)/cores
	cp ./workspace/$(PLATFORM)/cores/output/picodrive_libretro.so ./build/SYSTEM/$(PLATFORM)/cores
	cp ./workspace/$(PLATFORM)/cores/output/snes9x2005_plus_libretro.so ./build/SYSTEM/$(PLATFORM)/cores
	cp ./workspace/$(PLATFORM)/cores/output/pcsx_rearmed_libretro.so ./build/SYSTEM/$(PLATFORM)/cores

	# extras
	cp ./workspace/$(PLATFORM)/cores/output/mgba_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/MGBA.pak
	cp ./workspace/$(PLATFORM)/cores/output/mgba_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/SGB.pak
	cp ./workspace/$(PLATFORM)/cores/output/mednafen_pce_fast_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/PCE.pak
	cp ./workspace/$(PLATFORM)/cores/output/pokemini_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/PKM.pak
	cp ./workspace/$(PLATFORM)/cores/output/race_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/NGP.pak
	cp ./workspace/$(PLATFORM)/cores/output/race_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/NGPC.pak
	cp ./workspace/$(PLATFORM)/cores/output/mednafen_supafaust_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/SUPA.pak
	cp ./workspace/$(PLATFORM)/cores/output/mednafen_vb_libretro.so ./build/EXTRAS/Emus/$(PLATFORM)/VB.pak || true

common: build system cores

clean:
	rm -rf ./build

setup: name
	# ready fresh build
	rm -rf ./build
	mkdir -p ./releases
	cp -R ./skeleton ./build

	# remove authoring detritus
	cd ./build && find . -type f -name '.keep' -delete
	cd ./build && find . -type f -name '*.meta' -delete
	echo $(BUILD_HASH) > ./workspace/hash.txt

	mkdir -p ./workspace/readmes
	cp ./skeleton/BASE/README.txt ./workspace/readmes/BASE-in.txt
	cp ./skeleton/EXTRAS/README.txt ./workspace/readmes/EXTRAS-in.txt
	cd ./workspace/readmes && fmt -w 40 -s ./BASE-in.txt > ./BASE-out.txt 2>/dev/null || true
	cd ./workspace/readmes && fmt -w 40 -s ./EXTRAS-in.txt > ./EXTRAS-out.txt 2>/dev/null || true
	cd ./workspace/readmes && rm ./*-in.txt 2>/dev/null || true

done:
	say "done" 2>/dev/null || true

special:
	# setup .tmp_update
	mv ./build/BOOT/common ./build/BOOT/.tmp_update
	mv ./build/BOOT/trimui ./build/BASE/
	cp -R ./build/BOOT/.tmp_update ./build/BASE/trimui/app/

tidy:
	# no platform-specific tidying needed

package: tidy
	# move formatted readmes from workspace to build
	cp ./workspace/readmes/BASE-out.txt ./build/BASE/README.txt
	cp ./workspace/readmes/EXTRAS-out.txt ./build/EXTRAS/README.txt
	rm -rf ./workspace/readmes

	cd ./build/SYSTEM && echo "$(RELEASE_NAME)\n$(BUILD_HASH)" > version.txt
	cd ./build && find . -type f -name '.DS_Store' -delete
	mkdir -p ./build/PAYLOAD
	mv ./build/SYSTEM ./build/PAYLOAD/.system
	cp -R ./build/BOOT/.tmp_update ./build/PAYLOAD/

	cd ./build/PAYLOAD && zip -r MinUI.zip .system .tmp_update
	mv ./build/PAYLOAD/MinUI.zip ./build/BASE

	cd ./build/BASE && zip -r ../../releases/$(RELEASE_NAME)-base.zip Bios Roms Saves trimui em_ui.sh MinUI.zip README.txt
	cd ./build/EXTRAS && zip -r ../../releases/$(RELEASE_NAME)-extras.zip Bios Emus Roms Saves Tools README.txt
	echo "$(RELEASE_NAME)" > ./build/latest.txt
	
