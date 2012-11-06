X10C=/opt/x10/bin/x10c++

EXE=queens
OBJ_DIR=obj
SRC_DIR=src
FLAGS='-nooutput -O -NO_CHECKS=true'

rm -f ${EXE}

# We cd into the obj directory so that the generated files don't pollute the
# other directories
mkdir -p ${OBJ_DIR}
cd ${OBJ_DIR}

# Build the program.
${X10C} ${FLAGS} -o ../${EXE} ../${SRC_DIR}/*.x10

# Even with -nooutput, the compiler leaves some generated files.  Remove them.
rm -f *.h

# cd back into the root directory and run the generated X10 program
cd ..

./${EXE}
# srun ./${EXE}

