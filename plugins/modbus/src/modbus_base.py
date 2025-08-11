class ModbusBase:
    def __init__(self, word_num=2, precision=4):
        self._precision = precision
        self._word_num = word_num
        self._precision_factor = pow(10, precision)
        self._base = pow(2, 16)
        self._max_int = pow(self._base, word_num)

    def decode(self, word_array):

        if len(word_array) != self._word_num:
            raise ValueError('word array length is not correct')

        base_holder = 1
        result = 0

        for word in word_array:
            result *= base_holder
            result += word
            base_holder *= self._base

        return result / self._precision_factor

    def encode(self, number):

        number = int(number * self._precision_factor)

        if number > self._max_int:
            raise ValueError('input number exceed max limit')

        result = []
        while number:
            result.append(number % self._base)
            number = int(number / self._base)

        while len(result) < self._word_num:
            result.append(0)

        result.reverse()
        return result

    def get_registers(self, index):
        return index * self._word_num