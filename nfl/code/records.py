import sys
import csv
import datetime


def extract_date(aString):
    try:
        return datetime.datetime.strptime(aString, '%m/%d/%Y')
    except:
        return None


def process(file):
    line_num = 0
    last_date = datetime.datetime(1950, 1, 1)
    with open(file) as f:
        reader = csv.DictReader(f)
        for row in reader:
            current_line = row['schedule_date']
            d = extract_date(current_line)
            if d < last_date:
                print(row)
            line_num += 1
            last_date = d
    print("Processed", line_num, "lines")


if __name__ == '__main__':
    process(sys.argv[1])
