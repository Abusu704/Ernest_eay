--Car Rental System
#include <stdio.h>
#include <string.h>

void printReceipt(char car[], int days, float cost) {
    printf("\n==========* RENTAL RECEIPT *==========\n");
    printf("Car Rented: %s\n", car);
    printf("Rental Days: %d\n", days);
    printf("Total Cost: Ghc %.2f\n", cost);
        printf("Return the car within %d days\n",days);
    printf("===================================\n\n");

}


int main() {
    char category[3];
    int lexus_rented = 0, benz_rented = 0, brabus_rented = 0;
    int nissan_rented = 0, mitsu_rented = 0, mazda_rented = 0;
    int corolla_rented = 0, suzuki_rented = 0, opel_rented = 0;

    menu:
    printf("\n*** G-23 Car Rental System**\n");
    printf("WELCOME TO THE PLACE OF QUALITY AND AFORDABLE CARS\n");
    printf("Our Cars are classified into three categories:\n");
    printf("A - Luxury\nB - Business\nC - Economy\n");

    do {
        printf("Please select the category of your preference: ");
        scanf("%2s", category);
        while (getchar() != '\n'); // Clear input buffer

        if (category[0] != 'A' && category[0] != 'B' && category[0] != 'C') {
            printf("Not in our inventory. Please select a valid category.\n");
        }
    } while (category[0] != 'A' && category[0] != 'B' && category[0] != 'C');

    int days = 0;
    while (1) {
        printf("Enter the number of days you will be using the car: ");
        if (scanf("%d", &days) != 1 || days <= 0) {
            printf("Invalid input. Please enter a valid number.\n");
            while (getchar() != '\n'); // Clear input buffer
        } else {
            break;
        }
    }

    char c[20];
    float cost = 0;

    while (1) {
        printf("Select a car from the available options:\n");

        if (category[0] == 'A') { // Luxury Cars
            if (lexus_rented + benz_rented + brabus_rented == 3) {
                printf("All cars in category A are unavailable. Please select another category.\n");
                goto menu;
            }
            if (!lexus_rented) printf(" Lexus - Ghc 500 per day\n");
            if (!benz_rented) printf("Benz - Ghc 450 per day\n");
            if (!brabus_rented) printf("Brabus - Ghc 400 per day\n");
        }
        else if (category[0] == 'B') { // Business Cars
            if (nissan_rented + mitsu_rented + mazda_rented == 3) {
                printf("All cars in category B are unavailable. Please select another category.\n");
                goto menu;
            }
            if (!nissan_rented) printf("Nissan - Ghc 350 per day\n");
            if (!mitsu_rented) printf("Mitsu - Ghc 300 per day\n");
            if (!mazda_rented) printf("Mazda - Ghc 250 per day\n");
        }
        else if (category[0] == 'C') { // Economy Cars
            if (corolla_rented + suzuki_rented + opel_rented == 3) {
                printf("All cars in category C are unavailable. Please select another category.\n");
                goto menu;
            }
            if (!corolla_rented) printf("Corolla - Ghc 200 per day\n");
            if (!suzuki_rented) printf("Suzuki - Ghc 200 per day\n");
            if (!opel_rented) printf("Opel - Ghc 150 per day\n");
        }

        printf("\nEnter the car name exactly as shown: ");
        scanf("%s", c);
        while (getchar() != '\n'); // Clear input buffer

        // Cost Calculation Logic
        if (strcmp(c, "Lexus") == 0 && !lexus_rented) {
            cost = 500 * days;
            lexus_rented = 1;
            break;
        } else if (strcmp(c, "Benz") == 0 && !benz_rented) {
            cost = 450 * days;
            benz_rented = 1;
            break;
        } else if (strcmp(c, "Brabus") == 0 && !brabus_rented) {
            cost = 400 * days;
            brabus_rented = 1;
            break;
        } else if (strcmp(c, "Nissan") == 0 && !nissan_rented) {
            cost = 350 * days;
            nissan_rented = 1;
            break;
        } else if (strcmp(c, "Mitsu") == 0 && !mitsu_rented) {
            cost = 300 * days;
            mitsu_rented = 1;
            break;
        } else if (strcmp(c, "Mazda") == 0 && !mazda_rented) {
            cost = 250 * days;
            mazda_rented = 1;
            break;
        } else if (strcmp(c, "Corolla") == 0 && !corolla_rented) {
            cost = 200 * days;
            corolla_rented = 1;
            break;
        } else if (strcmp(c, "Suzuki") == 0 && !suzuki_rented) {
            cost = 200 * days;
            suzuki_rented = 1;
            break;
        } else if (strcmp(c, "Opel") == 0 && !opel_rented) {
            cost = 150 * days;
            opel_rented = 1;
            break;
        } else {
            printf("Not in our inventory or already rented. Please select a valid car.\n");
        }
    }

    printReceipt(c, days, cost);
    char y[3];
    printf("Do you want to rent another car? (y/n): ");
    scanf("%s", y);
    while (getchar() != '\n'); // Clear input buffer
    if (y[0] == 'y' || y[0] == 'Y') {
        goto menu;
    } else {
        printf("Thank you for using our service\n");
    }
    printf("ENJOY YOUR RIDE\n");
    return 0;
}
