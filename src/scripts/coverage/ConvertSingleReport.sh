GCOV_DIR=$1
TARGET_NAME=$2
OUTPUT_DIR=$3
SRC_ROOT=$4

echo "---ConvertSingleReport---"
echo "GCOV_DIR - $GCOV_DIR"
echo "TARGET_NAME - $TARGET_NAME"
echo "OUTPUT_DIR - $OUTPUT_DIR"
echo "SRC_ROOT - $SRC_ROOT"


cd "$GCOV_DIR"
echo "gcovr --xml --root=$SRC_ROOT > $OUTPUT_DIR/$TARGET_NAME.xml"
gcovr --xml --root="$SRC_ROOT" > "$OUTPUT_DIR/$TARGET_NAME.xml"

echo "=========="
