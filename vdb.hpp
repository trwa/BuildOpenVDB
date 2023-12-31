#pragma once

#include <cstdint>
#include <functional>
#include <tuple>

namespace vdb
{
using Voxel_t = uint32_t;
using Coord_t = int32_t;
using Point_t = std::tuple<Coord_t, Coord_t, Coord_t>;

class Store_t final
{
public:
    Store_t();

    ~Store_t();

    Voxel_t get(Point_t const& point) const;

    void set(Point_t const& point, Voxel_t value);

    void iterate(Point_t const& from, Point_t const& to, std::function<void(Point_t const& point, Voxel_t value)> const& read) const;

    void iterate(Point_t const& from, Point_t const& to, std::function<Voxel_t(Point_t const& point, Voxel_t value)> const& transform);

private:
    struct Impl_t;
    Impl_t* _pimpl;
};
}