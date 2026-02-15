# ST 表

ST表是用于解决**可重复贡献**（最大最小值、最大公因数等）问题的**区间总贡献**查询的数据结构。

ST表基于倍增思想，在序列上建立处若干个长度为 $2^k$ 的区间，通过两个最大长度区间贡献的合并，在 $O(1)$ 时间内快速求出所询问区间的总贡献。



## 建表

ST表是一张二维表，其中 `st[i][j]` 表示从第 $i$ 个位置开始，长度为 $2 ^ j$ 的区间内的总贡献。

ST 表的第一维长度 $n$ 即为序列的长度，第二维的长度 $m$ 根据序列的长度指定，最长区间的长度不超过序列长度，即 $2 ^ {m - 1} \leq n$，$m = \lfloor \log_2 n \rfloor + 1$。

初始时将所有 `st[i][0]` 赋值为序列中第 $i$ 个位置的贡献，表示从 $i$ 到 $i$ 长度为 $1$ 的区间。

```cpp
for (int i = 0; i < n; ++i)
{
    // contribute 函数用于规定如何贡献
    st[i][0] = contribute(i);
}
```

接下来对于后边的每一列 $j$，其区间长度为 $2 ^ j$，均由上一列两个长度为 $2 ^ {j - 1}$ 的区间合并而来，起点分别为 $i$ 和 $i + 2 ^ {j - 1}$。其中要保证两个区间都在序列范围内。

```c++
for (int j = 1; j < m; ++j)
{
    int len = 1 << (j - 1);
    for (int i = 0; i + len * 2 - 1 < n; ++i)
    {
        st[i][j] = merge(i, i + len, j - 1);
    }
}
```



## 查询

由于数据可重复贡献的性质，相同数据贡献多次不会对答案产生影响，因此只需找到若干个区间，保证区间合并后可以完全覆盖查询区间即可。

方便起见，可以从区间首位各选取一个长度不超过区间长度的最大区间。由于 ST表中储存的区间长度都是 $2$ 的幂次，根据倍增的性质，可以证明这两个小区间一定可以覆盖整个查询区间。其中每段区间的长度均为 $len = 2 ^ {\lfloor \log_2(r - l + 1) \rfloor}$，两段区间的起始点分别为 $l$ 和 $r - len + 1$。

将两区间贡献值合并即可得到区间总贡献。

>   [!Warning]
>
>   不要试图用多个区间不重不漏地覆盖整个区间，那是线段树的查询方式，会使询问的时间复杂度提升至 $O(\log_2 n)$。

```cpp
int query(int l, int r)
{
    int power = log2(r - l + 1);
    int len = 1 << power;
    // merge(i, j, power) 用于规定贡献合并结果
    return merge(l, r - len + 1, power);
}
```



## 模板

```cpp
class SparseTable
{
private:
    std::vector<int> v_;
    std::vector<std::vector<int>> table_;

public:
    SparseTable(const std::vector<int>& v)
    {
        build(v);
    }

public:
    int query(const int l, const int r) const
    {
        const int power{ static_cast<int>(log2(r - l + 1)) };
        const int len{ 1 << power };
        return merge(l, r - len + 1, power);
    }

private:
    void build(const std::vector<int>& v)
    {
        v_ = v;

        const int n{ static_cast<int>(v.size()) };
        const int m{ static_cast<int>(std::log2(n)) + 1 };
        table_.assign(n, std::vector<int>(m));

        for (int i{ 0 }; i < n; ++i)
        {
            table_[i][0] = contribute(i);
        }
        for (int j{ 1 }; j < m; ++j)
        {
            int len{ 1 << (j - 1) };
            for (int i{ 0 }; i + len * 2 - 1 < n; ++i)
            {
                table_[i][j] = merge(i, i + len, j - 1);
            }
        }
    }

    int contribute(const int index) const
    {
        // TODO: 规定初始贡献值
        return ;
    }

    int merge(const int i1, const int i2, const int j) const
    {
        // TODO: 规定贡献值合并结果
        return ;
    }
};
```

