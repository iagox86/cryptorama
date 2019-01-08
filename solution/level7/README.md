# Solution

Solution: `...`

# Walkthrough

First, use Solve.rb (padding oracle) the same way as Level 5:

```
ruby ./Solve.rb ded3e8a179a80f4f 36f5a32bbb0655d42447b912d1b3bc22857edb6b484e77cac0b1ab0281efbec104358d418af569a70f5c0a8eb58f90011a1163bb66f0a9c3cda1bffc37dab1ccde04035f0b4a6c7be87b9bd1c57002533e2a3b2de134da68a226ec698e7e1019bf953aed148a535512da42f4da9981e726a40a0c2eda7377b0edbecbdb4204767d408d2226e32a89301230d675115a11e7e527eab04c42f34f2c1dda2dc0100e72135b7c5757d7f4ed986f25e3d597554beea1e98fe3ad0c615f25da4a74658a36e72c5b7dee5250bba3dd6705b6000285cb3c26851dbf769185d2d829abfc06e37b64adf3499bad92a08f858ffa2da182b8a32bdc1c85c8e97e81cc153448cc132fb5138e169b2d95749618c682596fa355ffd3e1091f3ac9a2dc25f49a6cc59a24e6b7960174b91dc0a9a5c4684704b9c71573548769d5e901e1cbdae147c7

[...]

{"codename":"money_making_scheme","signature_alg":"sha256","script":"MS4gU3RlYWwgdGhlIHByb2Zlc3NvcidzIHBhY2thZ2UKMi4gSGlkZSBpdCBzb21ld2hlcmUgaGUnbGwgbmV2ZXIgdGhpbmsgdG8gbG9vawozLiA/Pz8KNC4gUHJvZml0IQ==","secret_length":16,"signature":"28e70c5e9b1896782adbdaf9efd54d62a477bf210808ada109404d1314118f0a"}

```

Then use hash_extender the way we did in Level 6 to update the hash:

