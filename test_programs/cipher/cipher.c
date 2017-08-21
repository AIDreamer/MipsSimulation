#include <stdio.h>

extern int puts(const char *str);

int modulo_cypher(int message, int mod_key) {
    return (message * mod_key) % 10;
}

int xor_cipher(int message, int xor_key) {
    return message ^ xor_key;   
}

int main(void) {
  char s[128] = {0};
  int xor_key = 777777777;
  int mod_en = 3;
  int mod_de = 7;
  int social_security = 594804314; // Fake SSN from Mississippi
  int code = 0;
  int digit = 0;
  int decode = 0;
   
  // Print the origin SSN (*)
  puts("Original SSN:\n");
  puts(itoa(social_security));
  puts("\n\n");

  // Cipher while loop
  while(social_security > 0) {
    digit = social_security % 10;
    social_security /= 10;
    code = code * 10 + modulo_cypher(digit, mod_en);
  }
  code = xor_cipher(code, xor_key);
  
  // Print the encoded message
  puts("Encoded SSN:\n");
  puts(itoa(code));
  puts("\n\n");

  // Decode it back
  code = xor_cipher(code, xor_key);

  while(code > 0) {
    digit = code % 10;
    code /= 10;
    decode = decode * 10 + modulo_cypher(digit, mod_de);
  }
  
  // Print the original message
  puts("Decoded SSN:\n");
  puts(itoa(decode));
  puts("\n\n");
}
