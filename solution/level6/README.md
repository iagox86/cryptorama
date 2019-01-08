# Solution

Solution: `were_almost_there_now`

# Walkthrough

This is a hash extension vulnerability.

First decode the field we're given and dump it in a file (or whatever):

```
echo 'MS4gU3RlYWwgdGhlIHByb2Zlc3NvcidzIHBhY2thZ2UKMi4gSGlkZSBpdCBzb21ld2hlcmUgaGUnbGwgbmV2ZXIgdGhpbmsgdG8gbG9vawozLiA/Pz8KNC4gUHJvZml0IQ==' | base64 -d > base64-test
```

Then use hash_extender to extend it:

```
./hash_extender --file=./base64-test --signature=b0247dfa8db16c0ab667469cdd326e738c9e8592e72858bbd902470d74700285 --secret=16 --append="5. Give back the package" --out-data-format=cstr-pure
```

Then find a way to massage the data back to Base64:

```
echo -ne '\x31\x2e\x20\x53\x74\x65\x61\x6c\x20\x74\x68\x65\x20\x70\x72\x6f\x66\x65\x73\x73\x6f\x72\x27\x73\x20\x70\x61\x63\x6b\x61\x67\x65\x0a\x32\x2e\x20\x48\x69\x64\x65\x20\x69\x74\x20\x73\x6f\x6d\x65\x77\x68\x65\x72\x65\x20\x68\x65\x27\x6c\x6c\x20\x6e\x65\x76\x65\x72\x20\x74\x68\x69\x6e\x6b\x20\x74\x6f\x20\x6c\x6f\x6f\x6b\x0a\x33\x2e\x20\x3f\x3f\x3f\x0a\x34\x2e\x20\x50\x72\x6f\x66\x69\x74\x21\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x88\x35\x2e\x20\x47\x69\x76\x65\x20\x62\x61\x63\x6b\x20\x74\x68\x65\x20\x70\x61\x63\x6b\x61\x67\x65' | base64 -w0

MS4gU3RlYWwgdGhlIHByb2Zlc3NvcidzIHBhY2thZ2UKMi4gSGlkZSBpdCBzb21ld2hlcmUgaGUnbGwgbmV2ZXIgdGhpbmsgdG8gbG9vawozLiA/Pz8KNC4gUHJvZml0IYAAAAAAAAAAAAAAAAADiDUuIEdpdmUgYmFjayB0aGUgcGFja2FnZQ==
```

Enter that, along with the new signature, and you're good to go!
