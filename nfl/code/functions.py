import unittest

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


class Test(unittest.TestCase):
    def test_good_int(self):
        self.assertTrue(is_int("17"))

    def test_good_float(self):
        self.assertTrue(is_float("17"))
        self.assertTrue(is_float("17.5"))

    def test_bad_number(self):
        self.assertFalse(is_int("foo"))
        self.assertFalse(is_float("foo"))


if __name__ == '__main__':
    unittest.main()

