#include <stdio.h>
#include <stdint.h>

extern uint64_t get_cycles();

uint16_t count_leading_zeros(uint64_t x)
{
    int time = 0;
    if(x==1)
        time++;
    while(x > 1){
        x>>=1;
        time+=1;
    }
    
    return (64-time);
}



int main() {
    uint64_t x_0 = get_cycles();
    int input_1 = 4;
    int input_2 = 8;
    int input_3 = 16;
    int input_4 = 32;
    printf("%d\n",64 - count_leading_zeros(input_1));
    printf("%d\n",64 - count_leading_zeros(input_2));
    printf("%d\n",64 - count_leading_zeros(input_3));
    printf("%d\n",64 - count_leading_zeros(input_4));
    printf("%lld\n",get_cycles() - x_0);    
    return 0;
}
