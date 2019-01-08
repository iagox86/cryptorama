# Solution

Solution: `lobster`

# Walkthrough

The only thing needed to finish this level is Dr. Z's password hash:

```
dr.z:23B3F108A5E26A0304616C255008EF87
```

Which, if you use John the Ripper, is easily cracked:

```
$ echo 'dr.z:23B3F108A5E26A0304616C255008EF87' > level4

$ ./john --wordlist=/home/ron/tmp/english.txt --format=nt ./level4
[...]
lobster          (dr.z)

$ ./john --show --format=nt ./level4
dr.z:lobster

1 password hash cracked, 0 left

```

Potential issues:

* If there's an error that the NT format isn't recognized, make sure that the
  john-jumbo patch is applied (`./john --list=formats`)
* If it doesn't appear to crack, try the `--show` command
