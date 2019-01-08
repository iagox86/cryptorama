# Solution

Solution: `project_make_professor_pay`

# Walkthrough

There are two parts to level 3, either one is enough to complete it.

## AES-256-ECB

To solve this, first set your `First name` to

```
aaaa,is_admin=1,
```

Repeated over and over and over, say 16 times, then encrypt it.

Then encrypt it and split into blocks. You'll see something like:

```
dc638c7a796079d2d0ad58b03fe34c8d 9b24c05bb09360d5922965bc1a06788e 9b24c05bb09360d5922965bc1a06788e 9b24c05bb09360d5922965bc1a06788e 9b24c05bb09360d5922965bc1a06788e 9b24c05bb09360d5922965bc1a06788e 9b24c05bb09360d5922965bc1a06788e 9b24c05bb09360d5922965bc1a06788e 315c54c7a0eb5dae849fa44ac6bce650 b4059c76ece164df74692b8296ee9189 1744c26410c87cab199aba2fd6f71455
```

You'll see one block that's repeated a lot. Put just that in the box and hit
"Check cookie!"

# Salsa20

Salsa20 is much easier. Simply take the last byte and xor it with `0x01`.

For example, I have the string:

```
4d918a9f5433762b081bb26c69a380390811059fcb5edb0b1831af5f691f15253c3b1e28
```

If I take the last byte (`0x28`) and xor it with `1`, I get `0x29`. I change
the 8 to a 9 and get the new string:

```
4d918a9f5433762b081bb26c69a380390811059fcb5edb0b1831af5f691f15253c3b1e29
```

Which enter, then hit "Check cookie!"
