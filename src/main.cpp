#include <map>
#include <string>

#include <SFML/Audio.hpp>
#include <SFML/Graphics.hpp>

#include <mruby.h>
#include <mruby/irep.h>

#include "../build/scripts_compiled.h"

#include <sys/poll.h>

static mrb_state *mrb;
static sf::RenderWindow window;
static sf::Font font;
static std::map<std::string, sf::Texture> texture_cache;

static void check_mruby_status()
{
    if (mrb->exc)
    {
        mrb_print_error(mrb);
        exit(1);
    }
}

static void call_mruby_func(const char *name)
{
    mrb_funcall(mrb, mrb_obj_value(mrb->top_self), name, 0);
    check_mruby_status();
}

static void call_mruby_func(const char *name, float arg)
{
    mrb_funcall(mrb, mrb_obj_value(mrb->top_self), name, 1, mrb_float_value(mrb, arg));
    check_mruby_status();
}

static mrb_value mruby_draw_text(mrb_state *mrb, mrb_value self)
{
    const char *text = NULL;
    mrb_float x, y;
    int args = mrb_get_args(mrb, "zff", &text, &x, &y);

    sf::Text object(text, font, 30);
    sf::FloatRect bounds = object.getLocalBounds();
    object.setPosition(x - bounds.width * 0.5f, y - bounds.height * 0.5f);
    object.setFillColor(sf::Color::Black);
    window.draw(object);
    return mrb_nil_value();
}

static mrb_value mruby_draw_sprite(mrb_state *mrb, mrb_value self)
{
    const char *name = NULL;
    mrb_float x, y;
    int args = mrb_get_args(mrb, "zff", &name, &x, &y);

    if (!texture_cache.count(name))
    {
        texture_cache[name].loadFromFile(name);
    }

    sf::Sprite object(texture_cache[name]);
    object.setPosition(x, y);
    window.draw(object);
    return mrb_nil_value();
}

static void init_mruby()
{
    RClass *engine = mrb_define_module(mrb, "Engine");
    mrb_define_class_method(mrb, engine, "draw_text", mruby_draw_text, MRB_ARGS_ARG(3, 0));
    mrb_define_class_method(mrb, engine, "draw_sprite", mruby_draw_sprite, MRB_ARGS_ARG(3, 0));
    check_mruby_status();
}

static bool data_available(FILE *file)
{
    struct pollfd fds;
    fds.fd = fileno(file);
    fds.events = POLLIN;
    int ret = poll(&fds, 1, 0);
    if (ret == 1)
        return true;
    else if (ret == 0)
        return false;
    else
        exit(EXIT_FAILURE);
}

static void reload_ruby_script(const char *path)
{
    FILE *file = fopen(path, "rb");
    if (!file)
        exit(EXIT_FAILURE);
    fseek(file, 0, SEEK_END);
    size_t file_length = ftell(file);
    fseek(file, 0, SEEK_SET);
    char *data = new char[file_length];
    fread(data, 1, file_length, file);
    fclose(file);
    mrbc_context *context = mrbc_context_new(mrb);
    mrbc_filename(mrb, context, path);
    mrb_parser_state *parser = mrb_parse_nstring(mrb, data, file_length, context);
    int num_errors = parser->nerr;
    mrb_parser_free(parser);
    if (num_errors > 0)
    {
        fprintf(stderr, "Parse error in %s.\n", path);
        mrbc_context_free(mrb, context);
        return;
    }
    mrb_load_nstring_cxt(mrb, data, file_length, context);
    mrbc_context_free(mrb, context);
    check_mruby_status();
}

int main()
{
    window.create(sf::VideoMode(1920, 1080), "mruby game demo");

    if (!font.loadFromFile("data/font/Roboto-Regular.ttf"))
        return EXIT_FAILURE;

    mrb = mrb_open();
    mrb_load_irep(mrb, mrb_scripts);
    check_mruby_status();
    init_mruby();

    call_mruby_func("main_init");

    FILE *watcher = popen("fswatch ./scripts/*.rb", "r");
    if (!watcher)
        return EXIT_FAILURE;

    sf::Clock clock;
    while (window.isOpen())
    {
        if (data_available(watcher))
        {
            char changed_file[640];
            if (fgets(changed_file, sizeof(changed_file), watcher))
            {
                changed_file[strlen(changed_file) - 1] = 0; // remove trailing \n
                fprintf(stderr, "Changed file [%s]\n", changed_file);
                reload_ruby_script(changed_file);
            }
            else
            {
                exit(EXIT_FAILURE);
            }
        }
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }
        sf::Time elapsed = clock.restart();
        call_mruby_func("main_update", elapsed.asSeconds());
        window.clear();
        call_mruby_func("main_render");
        window.display();
    }

    mrb_close(mrb);
    return EXIT_SUCCESS;
}
