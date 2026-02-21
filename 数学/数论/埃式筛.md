# 埃式筛

埃式筛是一种高效筛选出指定范围内的全部素数的算法。

由于质数的倍数（不含本身）一定是合数，所以从 $2$ 开始遍历所有数，如果遇到一个质数，将他的所有倍数标记为合数。

如果有一个数在遍历过程中没有被标记为合数，说明比他小的数里面没有他的因数，这个数是质数。

根据梅滕斯第二定理，该算法的时间复杂度为 $O(n \ln(\ln n))$，稍逊于线性筛的 $O(n)$，但在 $10 ^ 7$ 数据范围内差距很小，且代码量更简短。

**优化一**：对于任意 $a \times b = c,\ a > b$，在 $c$ 被 $a$ 标记之前一定已经被 $b$ 标记过，因此遍历 $a$ 的倍数时从 $a ^ 2$ 开始即可。

**优化二**：除 $2$ 以外的所有偶数均为合数，除 $2$ 以外的质数只会出现在奇数中，因此只需要遍历每个质数的奇数倍即可。

## 模板

```cpp
class Eratosthenes
{
private:
    std::vector<int> primes_;
    std::vector<bool> is_primes_;   // 仅保存奇数的映射

public:
    Eratosthenes(const int n)
    {
        build(n);
    }

public:
    bool judge(const int n) const
    {
        if (n % 2 == 0)
            return n == 2;
        int x{ n / 2 };
        return is_primes_[x];
    }

    const std::vector<int>& primes() const
    {
        return primes_;
    }

private:
    void build(const int n)
    {
        primes_.reserve(n / std::log(n));
        is_primes_.assign((n + 1) / 2, true);

        if (n >= 2)
            primes_.push_back(2);

        is_primes_[0] = false;
        for (int i{ 1 }; i < is_primes_.size(); ++i)
        {
            int x{ i * 2 + 1 };

            if (!is_primes_[i])
                continue;

            primes_.push_back(x);
            if (int64_t(x) * x > n)
                continue;
            for (int y{ x * x }; y <= n; y += x * 2)
            {
                int j{ y / 2 };
                is_primes_[j] = false;
            }
        }
    }
};
```

