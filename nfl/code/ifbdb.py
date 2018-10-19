import unittest
import datetime
import functools

def is_int(aString):
    try:
        int(aString)
        return True
    except ValueError:
        return False


def is_float(aString):
    try:
        float(aString)
        return True
    except ValueError:
        return False


def extract_date(aString):
    try:
        return datetime.datetime.strptime(aString, '%m/%d/%Y')
    except:
        return None


def update_past_weeks(history, val):
    length = len(history)
    h = history.copy()
    h.insert(0, val)
    return h[:length]


def past_total(history, weeks_past):
    return functools.reduce(lambda a, x: a + x, history[:weeks_past + 1], 0)


class Test(unittest.TestCase):

    def test_past_weeks(self):
        h = [1, 0, 1, 0, 0, 1, 1, 0, 1]
        self.assertEqual(1, past_total(h, 0))
        self.assertEqual(1, past_total(h, 1))
        self.assertEqual(2, past_total(h, 2))
        self.assertEqual(2, past_total(h, 3))
        self.assertEqual(2, past_total(h, 4))
        self.assertEqual(3, past_total(h, 5))
        self.assertEqual(4, past_total(h, 6))
        self.assertEqual(4, past_total(h, 7))
        self.assertEqual(5, past_total(h, 8))

    def test_past_weeks_update(self):
        h = [1, 0, 1, 0, 0, 1, 1, 1, 0]
        h2 = [0, 1, 0, 1, 0, 0, 1, 1, 1]
        h3 = [1, 1, 0, 1, 0, 0, 1, 1, 1]
        self.assertEqual(h2, update_past_weeks(h, False))
        self.assertEqual(h3, update_past_weeks(h, True))

    def test_good_int(self):
        self.assertTrue(is_int("17"))

    def test_good_float(self):
        self.assertTrue(is_float("17"))
        self.assertTrue(is_float("17.5"))

    def test_bad_number(self):
        self.assertFalse(is_int("foo"))
        self.assertFalse(is_float("foo"))

    def test_date(self):
        d = extract_date("12/10/2018")
        self.assertEqual(12, d.month)
        self.assertEqual(10, d.day)
        self.assertEqual(2018, d.year)


if __name__ == '__main__':
    unittest.main()

