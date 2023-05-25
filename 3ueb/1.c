#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>


int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <image_file>\n", argv[0]);
        return 1;
    }

    char *filename = argv[1];
    int fd = open(filename, O_RDONLY);
    if (fd == -1) {
        perror("Error opening file");
        return 1;
    }

    // Offset für das Aufnahmedatum (Beispielwert)
    off_t camera_name_offset = 0x9e;

    // Offset für Informationen über die Kamera (Beispielwert)
    off_t date_offset = 0xe4;

    // Puffer zum Lesen der Daten
    char buffer[256];

    // Lese das Aufnahmedatum
    if (lseek(fd, date_offset, SEEK_SET) == -1) {
        perror("Error seeking to date offset");
        close(fd);
        return 1;
    }

    if (read(fd, buffer, sizeof(buffer)) == -1) {
        perror("Error reading date");
        close(fd);
        return 1;
    }

    printf("Aufnahmedatum: %s\n", buffer);

    // Lese Informationen über die Kamera
    if (lseek(fd, camera_name_offset, SEEK_SET) == -1) {
        perror("Error seeking to camera name offset");
        close(fd);
        return 1;
    }

    if (read(fd, buffer, sizeof(buffer)) == -1) {
        perror("Error reading camera info");
        close(fd);
        return 1;
    }

    printf("Kamerainformationen: %s\n", buffer);

    // Schließe die Datei
    close(fd);

    return 0;
}

