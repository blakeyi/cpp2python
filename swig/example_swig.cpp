#include "example_swig.h"
#include <iostream>

MyClass::MyClass(){}

MyClass::~MyClass(){}


void MyClass::greet(const char* name)
{
    std::cout << "hello " << name << std::endl;
}