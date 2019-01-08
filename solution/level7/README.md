# Solution

Solution: `good_news_everyone_we_did_it`

# Walkthrough

First, use `Solve.rb` (padding oracle) the same way as Level 5:

```
$ ruby ./Solve.rb ded3e8a179a80f4f 36f5a32bbb0655d42447b912d1b3bc22857edb6b484e77cac0b1ab0281efbec104358d418af569a70f5c0a8eb58f90011a1163bb66f0a9c3cda1bffc37dab1ccde04035f0b4a6c7be87b9bd1c57002533e2a3b2de134da68a226ec698e7e1019bf953aed148a535512da42f4da9981e726a40a0c2eda7377b0edbecbdb4204767d408d2226e32a89301230d675115a11e7e527eab04c42f34f2c1dda2dc0100e72135b7c5757d7f4ed986f25e3d597554beea1e98fe3ad0c615f25da4a74658a36e72c5b7dee5250bba3dd6705b6000285cb3c26851dbf769185d2d829abfc06e37b64adf3499bad92a08f858ffa2da182b8a32bdc1c85c8e97e81cc153448cc132fb5138e169b2d95749618c682596fa355ffd3e1091f3ac9a2dc25f49a6cc59a24e6b7960174b91dc0a9a5c4684704b9c71573548769d5e901e1cbdae147c7

[...]

{"codename":"money_making_scheme","signature_alg":"sha256","script":"MS4gU3RlYWwgdGhlIHByb2Zlc3NvcidzIHBhY2thZ2UKMi4gSGlkZSBpdCBzb21ld2hlcmUgaGUnbGwgbmV2ZXIgdGhpbmsgdG8gbG9vawozLiA/Pz8KNC4gUHJvZml0IQ==","secret_length":16,"signature":"28e70c5e9b1896782adbdaf9efd54d62a477bf210808ada109404d1314118f0a"}

```

Then use hash_extender the way we did in Level 6 to update the hash:

```
$ ./hash_extender --file=base64-test --signature=28e70c5e9b1896782adbdaf9efd54d62a477bf210808ada109404d1314118f0a --secret=16 --append="5. Give back the package" --out-data-format=cstr-pure

Type: sha256
Secret length: 16
New signature: b67a0451de412ca996b461d8f2e4c9555dc78a44e53b7bbcf6744441a5d47031
New string: \x31\x2e\x20\x53\x74\x65\x61\x6c\x20\x74\x68\x65\x20\x70\x72\x6f\x66\x65\x73\x73\x6f\x72\x27\x73\x20\x70\x61\x63\x6b\x61\x67\x65\x0a\x32\x2e\x20\x48\x69\x64\x65\x20\x69\x74\x20\x73\x6f\x6d\x65\x77\x68\x65\x72\x65\x20\x68\x65\x27\x6c\x6c\x20\x6e\x65\x76\x65\x72\x20\x74\x68\x69\x6e\x6b\x20\x74\x6f\x20\x6c\x6f\x6f\x6b\x0a\x33\x2e\x20\x3f\x3f\x3f\x0a\x34\x2e\x20\x50\x72\x6f\x66\x69\x74\x21\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x88\x35\x2e\x20\x47\x69\x76\x65\x20\x62\x61\x63\x6b\x20\x74\x68\x65\x20\x70\x61\x63\x6b\x61\x67\x65

```

Convert the output to Base64:

```
$ echo -ne '\x31\x2e\x20\x53\x74\x65\x61\x6c\x20\x74\x68\x65\x20\x70\x72\x6f\x66\x65\x73\x73\x6f\x72\x27\x73\x20\x70\x61\x63\x6b\x61\x67\x65\x0a\x32\x2e\x20\x48\x69\x64\x65\x20\x69\x74\x20\x73\x6f\x6d\x65\x77\x68\x65\x72\x65\x20\x68\x65\x27\x6c\x6c\x20\x6e\x65\x76\x65\x72\x20\x74\x68\x69\x6e\x6b\x20\x74\x6f\x20\x6c\x6f\x6f\x6b\x0a\x33\x2e\x20\x3f\x3f\x3f\x0a\x34\x2e\x20\x50\x72\x6f\x66\x69\x74\x21\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x88\x35\x2e\x20\x47\x69\x76\x65\x20\x62\x61\x63\x6b\x20\x74\x68\x65\x20\x70\x61\x63\x6b\x61\x67\x65' | base64 -w0

MS4gU3RlYWwgdGhlIHByb2Zlc3NvcidzIHBhY2thZ2UKMi4gSGlkZSBpdCBzb21ld2hlcmUgaGUnbGwgbmV2ZXIgdGhpbmsgdG8gbG9vawozLiA/Pz8KNC4gUHJvZml0IYAAAAAAAAAAAAAAAAADiDUuIEdpdmUgYmFjayB0aGUgcGFja2FnZQ==
```

And re-encrypt the whole thing using `Poracle` (`Solve2.rb`):

```
ruby ./Solve2.rb ded3e8a179a80f4f 'MS4gU3RlYWwgdGhlIHByb2Zlc3NvcidzIHBhY2thZ2UKMi4gSGlkZSBpdCBzb21ld2hlcmUgaGUnbGwgbmV2ZXIgdGhpbmsgdG8gbG9vawozLiA/Pz8KNC4gUHJvZml0IYAAAAAAAAAAAAAAAAADiDUuIEdpdmUgYmFjayB0aGUgcGFja2FnZQ==' b67a0451de412ca996b461d8f2e4c9555dc78a44e53b7bbcf6744441a5d47031
```
