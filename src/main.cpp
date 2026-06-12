#include <defaultproject/app/application.hpp>

int main(int argc, char* argv[]) {
    defaultproject::app::Application app{argc, argv};
    return app.run();
}
