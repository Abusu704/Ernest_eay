--Simple Restaurant Food Ordering Program
#include <stdio.h>
#include <string.h>

void cont_dishes(){
    printf("Sushi\tTacos\tShawarma\tFish balls\t\n");
    printf("60\t200\t23\t12\t\n");
}
void code_A(){
    printf("Banku with okro soup(bos)-Ghc 25\nfufu with palm soup(fps)-Ghc 100\nRice with Kontomire(rk)-Ghc 56\n");
}

int main(){
    char menu_select;
    int sushi_1 =0, tacos_1=0, shawarma_1 = 0, fishballs_1 = 0;
    int bos_1 = 0, fps_1 = 0, rk_1 = 0;
     
    printf("\n\nMillennials Eatery\n");
    printf("Welcome to millenials Eatery\n");
    printf("We offer dishes for both local and continental\n");
    printf("To every food you buy 6 percent of it is donated to an orphanage\n");
    printf("Select menu of choice: Menu A(Local dishes)/Menu B(Continental dishes)\n");
    
    scanf("%c",&menu_select);
    if(menu_select == 'A'){
        printf("Every dish in this menu has being annoted with a unique code and it price\n");
        code_A();
    }else if(menu_select == 'B'){
        cont_dishes();
    }

    float bos = 25, fps = 100, rk = 56;
    float tacos = 200, sushi = 60, shawarma = 23, fish_balls = 12;
    char food_choice[20];
    
        
    printf("Order your preferred dish\n");
    
    scanf("%s",&food_choice);
    if(strcmp(food_choice,"bos")==0){
        printf("Cost: GHc %.2f", bos +(0.06*bos));
    }else if(strcmp(food_choice,"fps")==0){
        printf("Cost : Ghc %.2f", fps + (0.06*fps));
    }else if(strcmp(food_choice,"rk")==0){
        printf("Cost: Ghc %.2f", rk + (0.06*rk));
    }

    if(strcmp(food_choice,"tacos")==0){
        printf("Cost: $%f",tacos+(0.08*tacos));
    }else if(strcmp(food_choice,"sushi")==0){
        printf("Cost: $%f",sushi+(0.08*sushi));
    }else if(strcmp(food_choice,"shawarma")==0){
        printf("Cost: $%f",shawarma+(0.08*shawarma));

    }else if(strcmp(food_choice,"fishballs")==0){
        printf("Cost: $%f",fish_balls+(0.08*fish_balls));
        
    }
    
        printf("\n\n***=========Thank you for dinning with us==========***\n");

    
    
    return 0;
}


    
