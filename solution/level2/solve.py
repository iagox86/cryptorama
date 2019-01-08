import sys

seed = 0

def rand(max):
  global seed
  seed = ((seed * 214013) + 2531011) % 0x00FFFFFF
  return seed % max

def gen_password():
  p = ''
  for i in range(0, 12):
    p += '%02x' % rand(256)

  return p

if len(sys.argv) != 2:
  print "Usage: %s <password>" % sys.argv[0]
  sys.exit()

for i in range(0, 0xFFFFFF):
  seed = i
  if gen_password() == sys.argv[1]:
    print "Found it!"
    print gen_password()
    sys.exit()
