#include <iostream>
#include <functional>

#include <openvdb/openvdb.h>
#include <openvdb/tools/ValueTransformer.h>

using std::cout;
using std::endl;
using std::get;
using std::function;

using openvdb::CoordBBox;
using openvdb::Coord;
using openvdb::MaskGrid;

int main()
{
    openvdb::initialize();

    auto world = openvdb::Grid<openvdb::UInt32Tree>::create();

    auto apply_mask = [&world](auto const& from, auto const& to)
    {
        MaskGrid mask;
        mask.sparseFill({from, to}, true);
        world->topologyUnion(mask);
        world->topologyIntersection(mask);
        mask.clear();
    };

    using read_t = function<void(Coord const& c, uint32_t value)>;

    auto iterate = [&world, &apply_mask](auto const& from, auto const& to, read_t const& read)
    {
        apply_mask(from, to);

        for (auto iter = world->cbeginValueOn(); iter; ++iter)
        {
            read(iter.getCoord(), iter.getValue());
        }
    };

    constexpr auto from = Coord{0, 0, 0};
    constexpr auto to = Coord{1, 1, 1};

    auto print_values = [&iterate, &from, &to]()
    {
        iterate(from, to, [](auto const& point, auto value)
        {
            cout << "Point: " << point << '\n';
            cout << "Value: " << value << '\n';
            cout << "---" << endl;
        });
    };

    cout << "Empty:\n---" << endl;
    print_values();

    world->getAccessor().setValue({1, 0, 0}, 42);

    cout << "One value set:\n---" << endl;
    print_values();

    return 0;
}
