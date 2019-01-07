# Solution

Solution: `poor_unprivileged_guest`

# Walkthrough

This is simply a broken RNG. The script [solve.py](solve.py) takes a single
parameter and bruteforces the sequence.

For example, I hit "Reset!" and get:

```
You reset your test password to 8f629bc628d61ceb2e197f63
Dr. Z's password is set to the following!
Good luck!
```

I plug that value into my script, and the answer pops out:

```
$ python solution/level2/solve.py 8f629bc628d61ceb2e197f63
Found it!
4b0ef7942ff6bb08bde68068
```
