#include <iostream>
#include "vdb.hpp"
int main()
{
    vdb::Store_t store;
    auto from = vdb::Point_t{0, 0, 0};
    auto to = vdb::Point_t{1, 1, 1};
    store.iterate(from, to, [](auto const& point, auto value) {
        std::cout << "point: " << std::get<0>(point) << ", " << std::get<1>(point) << ", " << std::get<2>(point) << '\n';
        std::cout << "value: " << value << '\n';
        std::cout << "---" << std::endl;
    });
    return 0;
}