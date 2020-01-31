# IST 652
## Lab 1 
### Kendra Osburn
#### July 17, 2019

```python
NBAfile = open ('NBA-Attendance-1989.txt', 'r')
count = 0
NBAlist = [ ]
for line in NBAfile:
  count += 1
  textline = line.strip()
  items = textline.split()
  NBAlist.append(items)

print('Number of teams:', count)

for line in NBAlist:
		print('The attendance at ' + line[0] + " was " + line[1] + " and the ticket price was $" + line[2])

NBAfile.close()
```

#### OUTPUT
Number of teams: 27
The attendance at Atlanta was 13993 and the ticket price was $20.06
The attendance at Boston was 14916 and the ticket price was $22.54
The attendance at Charlotte was 23901 and the ticket price was $17
The attendance at Chicago was 18404 and the ticket price was $21.98
The attendance at Cleveland was 16969 and the ticket price was $19.63
The attendance at Dallas was 16868 and the ticket price was $17.05
The attendance at Denver was 12668 and the ticket price was $17.4
The attendance at Detroit was 21454 and the ticket price was $24.42
The attendance at Golden_State was 15025 and the ticket price was $17.04
The attendance at Houston was 15846 and the ticket price was $17.56
The attendance at Indiana was 12885 and the ticket price was $13.77
The attendance at LA_Clippers was 11869 and the ticket price was $21.95
The attendance at LA_Lakers was 17378 and the ticket price was $29.18
The attendance at Miami was 15008 and the ticket price was $17.6
The attendance at Milwaukee was 16088 and the ticket price was $14.08
The attendance at Minnesota was 26160 and the ticket price was $10.92
The attendance at New_Jersey was 12160 and the ticket price was $13.31
The attendance at New_York was 17815 and the ticket price was $22.7
The attendance at Orlando was 15606 and the ticket price was $20.47
The attendance at Philadelphia was 14017 and the ticket price was $19.04
The attendance at Phoenix was 14114 and the ticket price was $16.59
The attendance at Portland was 12884 and the ticket price was $22.19
The attendance at Sacramento was 17014 and the ticket price was $16.96
The attendance at San_Antonio was 14722 and the ticket price was $16.79
The attendance at Seattle was 12244 and the ticket price was $18.11
The attendance at Utah was 12616 and the ticket price was $18.41
The attendance at Washington was 11565 and the ticket price was $14.55