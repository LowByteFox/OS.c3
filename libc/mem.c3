/* SPDX-License-Identifier: BSD-2-Clause */
module libc;

fn void *memmove(void *d, void *s, usz n) @export("memmove")
{
	char *dst = (char*) d;
	char *src = (char*) s;
	if (dst < src) {
		for (usz i = 0; i < n; i++) dst[i] = src[i];
	} else {
		for (usz i = n; i != 0; i--) dst[i-1] = src[i-1];
	}

	return d;
}

fn int memcmp(void *src, void *src2, usz n) @export("memcmp")
{
	char *a = (char*) src;
	char *b = (char*) src2;
	for (usz i = 0; i < n; i++) {
		if (a[i] < b[i]) {
            return -1;
		} else if (b[i] < a[i]) {
			return 1;
        }
	}
	return 0;
}

fn void *memset(void *dst, int v, usz n) @export("memset")
{
	char *d = (char*) dst;
	for (usz i = 0; i < n; i++) d[i] = (char) v;

	return d;
}

fn void *memcpy(void *dst, void *src, usz n) @export("memcpy")
{
	char *d = (char*) dst;
	char *s = (char*) src;
	for (usz i = 0; i < n; i++) d[i] = s[i];

	return d;
}
