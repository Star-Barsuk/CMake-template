#include <defaultproject/util/cstring.hpp>

#include <cassert>

int main() {
    assert(defaultproject::util::streq("abc", "abc"));
    assert(!defaultproject::util::streq("abc", "abd"));
    assert(defaultproject::util::starts_with("--help", '-'));
    assert(!defaultproject::util::starts_with("help", '-'));
    return 0;
}
