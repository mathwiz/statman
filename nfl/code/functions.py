import unittest

def is_int(aString):
    try:
        int(aString)
        return True
    except ValueError:
        return False


class Test(unittest.TestCase):
    def test_good_int(self):
        self.assertTrue(is_int("17"))


if __name__ == '__main__':
    unittest.main()

