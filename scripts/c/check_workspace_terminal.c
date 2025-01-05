#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <stdbool.h>
#include <errno.h>

#define WINDOW_CONSTANT "Window"
#define WORKSPACE_NAME_CONSTANT "workspace"
#define CLASS_NAME_CONSTANT "class"
#define SPLIT_FILTER ": "

// Obtiene la salida estándar de un comando y la retorna como un string dinámico.
// El buffer resultante debe ser liberado por el llamante.
static char* get_process_stdout(const char *cmd) {
    FILE *fp = popen(cmd, "r");
    if (!fp) {
        fprintf(stderr, "Error ejecutando %s: %s\n", cmd, strerror(errno));
        return NULL;
    }

    // Vamos a leer la salida completa del comando en memoria.
    // Estrategia: leer en bloques y realocar si es necesario.
    // Sin embargo, generalmente los comandos no devuelven grandes cantidades de datos.
    // Para evitar sobrecarga dinámica innecesaria, usamos un bloque grande.
    // Si se espera que la salida sea mayor, se puede implementar una realocación dinámica.
    size_t buf_size = 8192;
    char *output = (char*)malloc(buf_size);
    if (!output) {
        pclose(fp);
        return NULL;
    }

    size_t offset = 0;
    size_t n;
    while ((n = fread(output + offset, 1, buf_size - offset - 1, fp)) > 0) {
        offset += n;
        if (offset >= buf_size - 1) {
            // Realocar si se llena el buffer
            buf_size *= 2;
            char *tmp = realloc(output, buf_size);
            if (!tmp) {
                free(output);
                pclose(fp);
                return NULL;
            }
            output = tmp;
        }
    }
    output[offset] = '\0';
    pclose(fp);
    return output;
}

// Obtiene la salida del comando "hyprctl clients" para listar ventanas.
static char* get_windows(void) {
    return get_process_stdout("hyprctl clients");
}

// Obtiene el comando del terminal leyendo el archivo terminal.sh en ~/.config/ml4w/settings/
static char* get_terminal_command(void) {
    // Primero obtener el usuario actual con whoami
    char *user = get_process_stdout("whoami");
    if (!user) {
        return NULL;
    }

    // Remover salto de línea
    char *nl = strchr(user, '\n');
    if (nl) *nl = '\0';

    // Construir ruta
    char path[1024];
    snprintf(path, sizeof(path), "/home/%s/.config/ml4w/settings/terminal.sh", user);
    free(user);

    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "Archivo terminal.sh no encontrado.\n");
        return NULL;
    }

    // Leer comando terminal (asumimos una sola línea)
    char line[1024];
    if (!fgets(line, sizeof(line), f)) {
        fclose(f);
        return NULL;
    }
    fclose(f);

    // Remover salto de línea
    nl = strchr(line, '\n');
    if (nl) *nl = '\0';

    // Duplicar en memoria dinámica
    char *terminal = strdup(line);
    return terminal;
}

int main(int argc, char *argv[]) {
    struct timespec start_time, end_time;
    clock_gettime(CLOCK_MONOTONIC_RAW, &start_time);

    if (argc < 2) {
        // No se proporcionó WORKSPACE
        clock_gettime(CLOCK_MONOTONIC_RAW, &end_time);
        long diff = (end_time.tv_sec - start_time.tv_sec) * 1000000000L + 
                    (end_time.tv_nsec - start_time.tv_nsec);
        double millis = diff / 1000000.0;
        printf("Execution time in millis: %.3f\n", millis);
        return 0;
    }

    const char *WORKSPACE = argv[1];

    char *windows = get_windows();
    if (!windows) {
        // Si falla la obtención de ventanas, salir.
        clock_gettime(CLOCK_MONOTONIC_RAW, &end_time);
        long diff = (end_time.tv_sec - start_time.tv_sec) * 1000000000L + 
                    (end_time.tv_nsec - start_time.tv_nsec);
        double millis = diff / 1000000.0;
        printf("Execution time in millis: %.3f\n", millis);
        return 0;
    }

    char *terminal = get_terminal_command();
    if (!terminal) {
        free(windows);
        clock_gettime(CLOCK_MONOTONIC_RAW, &end_time);
        long diff = (end_time.tv_sec - start_time.tv_sec) * 1000000000L + 
                    (end_time.tv_nsec - start_time.tv_nsec);
        double millis = diff / 1000000.0;
        printf("Execution time in millis: %.3f\n", millis);
        return 0;
    }

    bool found_window = false;
    bool found_workspace = false;
    bool found_class = false;

    // Parsear línea por línea la salida de "hyprctl clients"
    // La salida está en windows.
    char *saveptr = NULL;
    char *line = strtok_r(windows, "\n", &saveptr);

    while (line) {
        // Trim inicial y final (opcional, se puede obviar si no hay espacios)
        while (*line == ' ' || *line == '\t') line++;

        if (*line == '\0') {
            // línea vacía
            found_window = false;
            found_workspace = false;
            found_class = false;
        } else if (strstr(line, WINDOW_CONSTANT)) {
            found_window = true;
        } else if (found_window) {
            // Convertimos la línea a minúsculas para comparaciones
            // (Solo en caso necesario, la comparación se hace en minúsculas en el Python original)
            char lower_line[1024];
            size_t len = strlen(line);
            if (len >= sizeof(lower_line)) len = sizeof(lower_line)-1;
            for (size_t i = 0; i < len; i++) {
                lower_line[i] = (char)((line[i] >= 'A' && line[i] <= 'Z') ? (line[i] + 32) : line[i]);
            }
            lower_line[len] = '\0';

            // Splitear por ": "
            char *val = strstr(lower_line, SPLIT_FILTER);
            if (!val) {
                // no se encontró separador
                // no hacer nada
            } else {
                *val = '\0'; // cortar string
                val += 2;    // apunta al valor

                // Chequear keys
                if (strcmp(lower_line, WORKSPACE_NAME_CONSTANT) == 0) {
                    if (strstr(val, WORKSPACE)) {
                        found_workspace = true;
                    }
                } else if (strcmp(lower_line, CLASS_NAME_CONSTANT) == 0) {
                    if (strstr(val, terminal)) {
                        found_class = true;
                    }
                }
            }
        }

        if (found_workspace && found_class) {
            // Se encontró lo que buscábamos
            break;
        }

        line = strtok_r(NULL, "\n", &saveptr);
    }

    if (!(found_workspace && found_class)) {
        printf("Kitty no está en ejecución en el workspace %s. Iniciando Kitty...\n", WORKSPACE);
        // Ejecutar el terminal
        // Ejecutamos con execlp o system.
        // Para mayor eficiencia, mejor posix_spawn o fork+exec, pero para simplicidad:
        pid_t pid = fork();
        if (pid == 0) {
            // Proceso hijo
            execlp(terminal, terminal, NULL);
            // Si falla:
            fprintf(stderr, "No se pudo ejecutar el terminal: %s\n", strerror(errno));
            _exit(1);
        }
    }

    free(windows);
    free(terminal);

    clock_gettime(CLOCK_MONOTONIC_RAW, &end_time);
    long diff = (end_time.tv_sec - start_time.tv_sec) * 1000000000L + 
                (end_time.tv_nsec - start_time.tv_nsec);
    double millis = diff / 1000000.0;
    printf("Execution time in millis: %.3f\n", millis);

    return 0;
}
