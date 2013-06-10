CC=gcc
CFLAGS=-O2 -Wall -g -D_FORTIFY_SOURCE=2 -fstack-protector -fPIC
all: reference

OBJS= crypto_scrypt-nosse.o sha256.o crypto_scrypt-hexconvert.o crypto-mcf.o modp_b64.o crypto-scrypt-saltgen.o crypto_scrypt-check.o crypto_scrypt-hash.o


library: $(OBJS)
	$(CC) -shared -Wl,-soname,libscrypt.so.0 -Wl,--version-script=libscrypt.version -o libscrypt.so -lc  $(OBJS)

reference: library main.o
	$(CC) -Wall -o reference main.o -Wl,-rpath=. -L.  -lm  -lscrypt

clean:
	rm -f *.o reference libscrypt.so

check: all
	./reference
