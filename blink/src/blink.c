#include <stdint.h>

#define PERIPHERAL_BASE         (0x40000000U)
#define RCC_BASE                (PERIPHERAL_BASE + 0x21000U)
#define RCC_APB1ENR             ((volatile uint32_t*)(RCC_BASE + 0x1CU))
#define RCC_APB2ENR             ((volatile uint32_t*)(RCC_BASE + 0x18U))

#define RCC_AHB2ENR_IOPCEN      (4)



#define GPIOC_BASE              (PERIPHERAL_BASE + 0x11000U)

#define GPIOC_CRL               ((volatile uint32_t*)(GPIOC_BASE + 0x00U))
#define GPIOC_CRH               ((volatile uint32_t*)(GPIOC_BASE + 0x04U))

#define PIN_OE_50MHZ            (0x3)

#define PIN13_CRH_MODE_POS        (20)
#define PIN13_MODE_OE_MASK      ((uint32_t)(PIN_OE_50MHZ << PIN13_CRH_MODE_POS))

#define PIN13_POS               (13)
#define PIN13_MASK              ((uint32_t)(1 << PIN13_POS))


#define GPIOC_ODR               ((volatile uint32_t*)(GPIOC_BASE + 0x0CU))

void Internal_LED_OE(void);
void Internal_LED_ON(void);
void Internal_LED_OFF(void);
void Internal_LED_Toggle(void);





int main(void){

    /* init */
    *RCC_APB2ENR |= ((uint32_t)(1 << RCC_AHB2ENR_IOPCEN));
    
    Internal_LED_OE();

    Internal_LED_OFF();
    while (1){
        Internal_LED_Toggle();
        for (uint32_t i = 0; i < 1000000; i++);
    }
    
}






void Internal_LED_OE(void){
    *GPIOC_CRH |= PIN13_MODE_OE_MASK;
}

void Internal_LED_ON(void){
    *GPIOC_ODR |= PIN13_MASK;
}

void Internal_LED_OFF(void){
    *GPIOC_ODR &= ~PIN13_MASK;
}

void Internal_LED_Toggle(void){
    *GPIOC_ODR ^= PIN13_MASK;
}