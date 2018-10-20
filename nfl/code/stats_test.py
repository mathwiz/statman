import unittest
import functools
import statistics

five = [0,1,2,3,4]
seven = [0,1,2,3,4,5,6]
nine = [0,1,2,3,4,5,6,7,8]

def mean(arr):
    return statistics.mean(arr)

def mean_sub(arr, number):
    return statistics.mean(arr[:number + 1])


class Test(unittest.TestCase):

    def test_mean(self):
        self.assertEqual(2.0, mean(five))
        self.assertEqual(3.0, mean(seven))
        self.assertEqual(4.0, mean(nine))

    def test_mean_subsetted(self):
        self.assertEqual(1.5, mean_sub(five, 3))
        self.assertEqual(1.5, mean_sub(seven, 3))
        self.assertEqual(1.5, mean_sub(nine, 3))


if __name__ == '__main__':
    unittest.main()

