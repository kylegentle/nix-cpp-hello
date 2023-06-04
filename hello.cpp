/*
    This file is copied from LearnCPP, which suggests using it to test that your compiler supports C++20.
    
    https://www.learncpp.com/cpp-tutorial/configuring-your-compiler-choosing-a-language-standard/#example20
*/ 

#include <array>
#include <iostream>
#include <span>


struct Foo
{
    int a{};
    int b{};
    int c{};
};

consteval int sum(std::span<const int> a) // std::span and consteval
{
    int s{0};
    for (auto n : a)
        s += n;
    return s;
}

auto sum(auto x, auto y) -> decltype(x + y) // abbreviated function templates
{
    return x + y;
}

int main()
{
    constexpr std::array a{3, 2, 1};
    constexpr int s{sum(a)};
    std::cout << s << '\n';

    Foo f1{.a = 1, .c = 3}; // designated initializers
    std::cout << sum(f1.a, f1.c) << '\n';

    return 0;
}