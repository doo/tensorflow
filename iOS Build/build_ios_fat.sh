WORKING_DIR=`pwd`
TARGET_DIR="${WORKING_DIR}/Build"
LIB_DIR="${TARGET_DIR}/lib"
INC_DIR="${TARGET_DIR}/include"

echo "Working dir = ${WORKING_DIR}"
cd ../tensorflow/lite/tools/make

chmod +x build_ios_universal_lib.sh
chmod +x download_dependencies.sh

echo "Downloading dependencies..."
./download_dependencies.sh

echo "Building universal lib..."
./build_ios_universal_lib.sh

rm -dfr "${TARGET_DIR}"
mkdir "${TARGET_DIR}"
mkdir "${LIB_DIR}"
mkdir "${INC_DIR}"

echo "Copying lib in place..."
cp "gen/lib/libtensorflow-lite.a" "${LIB_DIR}"


echo "Copying sources in place..."
cd "${WORKING_DIR}"
cp -pR "../tensorflow" "${INC_DIR}"

echo "Cleaning sources and extract headers..."
cd "${TARGET_DIR}"
find ./include -type f -not \( -name '*.h' -or -name '*.hpp' \) -delete
rm -R ./include/tensorflow/python
rm -R ./include/tensorflow/java
rm -R ./include/tensorflow/js
rm -R ./include/tensorflow/docs_src
rm -R ./include/tensorflow/examples
rm -R ./include/tensorflow/g3doc
rm -R ./include/tensorflow/go
rm -R ./include/tensorflow/lite/tutorials
rm -R ./include/tensorflow/lite/testdata

echo "Copying third-party headers..."
cp -pR "./include/tensorflow/lite/tools/make/downloads/absl/absl" "${INC_DIR}"
cp -pR "./include/tensorflow/lite/tools/make/downloads/flatbuffers/include/flatbuffers" "${INC_DIR}"

rm -R ./include/tensorflow/lite/tools
