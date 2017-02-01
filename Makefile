CFLAGS=-Iinclude
LDFLAGS=-Llib -lmath
OBJ=obj/math.o obj/private/private_math.o
LIB=lib/libmath.a lib/libmath.so
TEST=test/test.out

all: lib test

lib: $(LIB)

lib/libmath.a: $(OBJ)
	ar -qv $@ $^

lib/libmath.so: $(OBJ)
	gcc -shared -o $@ $^

obj/%.o: src/%.c
	gcc -fpic -c $< -o $@ $(CFLAGS)

test: $(TEST)

test/%.out: test/%.c lib/libmath.a lib/libmath.so
	gcc -o $@ $< $(CFLAGS) $(LDFLAGS)
#	gcc -o $@ $< $(CFLAGS) $(LDFLAGS)

check:lib/libmath.a
	ar -t $^
	nm $^
	otool -L lib/libmath.so

clean:
	rm $(OBJ) $(LIB) $(TEST)
