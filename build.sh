readonly antlr=antlr-4.11.1-complete.jar

curl -O https://www.antlr.org/download/$antlr

cmake --preset debug
cmake --build --preset debug
ctest --preset debug