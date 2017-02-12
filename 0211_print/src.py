
print('str1', 'str2', 'str3')

print('str1', 'str2', 'str3', sep=':')

x = ['a', 'b', 'c']
print(*x, sep='')

print()

print('str1', end='end')


with open('out.txt', 'w') as f:
    print('str', file=f)
