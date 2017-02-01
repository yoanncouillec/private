all: static shared test
test: test/static test/shared

### STATIC ###

static: lib/static/libmath.a

lib/static/libmath.a: obj/static/math.o obj/static/private/private_math.o
	ar -qv $@ $^

obj/static/%.o: src/%.c
	gcc -c $< -o $@ -Iinclude

test/static: test/static/test.out

test/static/%.out: test/%.c lib/static/libmath.a
	gcc -static -o $@ $< -Iinclude -Llib/static -lmath
	$@

### SHARED ###

shared: lib/shared/libmath.so

lib/shared/libmath.so: obj/shared/math.o obj/shared/private/private_math.o
	gcc -shared -o $@ $^

obj/shared/%.o: src/%.c
	gcc -fpic -c $< -o $@ -Iinclude

test/shared: test/shared/test.out

test/shared/%.out: test/%.c lib/shared/libmath.so
	gcc -o $@ $< -Iinclude -Llib/shared -lmath
	LD_LIBRARY_PATH=lib/shared $@
clean:
	find . -type f -name '*.o' -delete
	find . -type f -name '*.a' -delete
	find . -type f -name '*.so' -delete
	find . -type f -name '*.out' -delete
