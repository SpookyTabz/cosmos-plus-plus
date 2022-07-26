Cflags = -m32 -Iheaders -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore -Wno-write-strings -fcheck-new -std=c++17

Objects = obj/loader.o \
		  obj/kernel.o

obj/%.o: src/%.cpp
	mkdir -p $(@D)
	g++ $(Cflags) -c -o $@ $<

obj/%.o: src/%.s
	mkdir -p $(@D)
	as --32 -o $@ $<

kernel.bin: linker.ld $(Objects)
	mkdir -p bin
	ld -melf_i386 -T $< -o bin/$@ $(Objects)

kernel.iso: kernel.bin
	mkdir -p iso
	mkdir -p iso/boot
	mkdir -p iso/boot/grub
	cp bin/$< iso/boot/
	echo 'set timeout=0' > iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo 'menuentry "os" {' >> iso/boot/grub/grub.cfg
	echo '	multiboot /boot/kernel.bin' >> iso/boot/grub/grub.cfg
	echo '	boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=bin/$@ iso # implements the iso dir to kernel.iso
	rm -rf iso # remove the iso dir

image: kernel.iso #only command needed to run xD