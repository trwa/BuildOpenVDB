#include "vdb.hpp"

#include <openvdb/openvdb.h>
#include <openvdb/tools/ValueTransformer.h>

namespace vdb
{
using Grid_t = openvdb::Grid<openvdb::UInt32Tree>;
using WorldPtr_t = decltype(Grid_t::create());

using openvdb::Coord;

using openvdb::MaskGrid;
using openvdb::CoordBBox;

struct Store_t::Impl_t
{
    WorldPtr_t world = nullptr;
};

Store_t::Store_t() : _pimpl{new Impl_t()}
{
    openvdb::initialize();
    _pimpl->world = Grid_t::create();
}

Store_t::~Store_t()
{
    delete _pimpl;
    _pimpl = nullptr;
}

static auto _coord(Point_t const& point)
{
    auto [x, y, z] = point;
    return openvdb::Coord(x, y, z);
}

static auto _point(Coord const& coord)
{
    auto x = coord.x();
    auto y = coord.y();
    auto z = coord.z();
    return Point_t{x, y, z};
}

Voxel_t Store_t::get(Point_t const& point) const
{
    auto accessor = _pimpl->world->getAccessor();
    return accessor.getValue(_coord(point));
}

void Store_t::set(Point_t const& point, Voxel_t value)
{
    auto accessor = _pimpl->world->getAccessor();
    accessor.setValue(_coord(point), value);
}

static void _mask(WorldPtr_t& world, Point_t const& from, Point_t const& to)
{
    CoordBBox box(_coord(from), _coord(to));
    MaskGrid mask;
    mask.sparseFill(box, true);
    world->topologyUnion(mask);
    world->topologyIntersection(mask);
    mask.clear();
}

void Store_t::iterate(Point_t const& from, Point_t const& to, std::function<void(Point_t const& point, Voxel_t value)> const& read) const
{
    auto& world = _pimpl->world;
    _mask(world, from, to);

    for (auto iter = world->cbeginValueOn(); iter; ++iter)
    {
        auto value = iter.getValue();
        auto coord = iter.getCoord();
        read(_point(coord), value);
    }
}

void Store_t::iterate(Point_t const& from, Point_t const& to, std::function<Voxel_t(Point_t const& point, Voxel_t value)> const& transform)
{
    auto& world = _pimpl->world;
    _mask(world, from, to);

    for (auto iter = world->beginValueOn(); iter; ++iter)
    {
        auto value = iter.getValue();
        auto coord = iter.getCoord();
        iter.setValue(transform(_point(coord), value));
    }
}
}