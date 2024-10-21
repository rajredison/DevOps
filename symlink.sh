[root@w2rscewebdevn01 tmp]# cat symlink.sh
#!/bin/bash
# Directory to be created

export SWORK=/shared-workspace
export SSCRATCH=/shared-scratch
DIR1="workspace"
DIR2="scratch"
DIR1_PATH="$SHOME/${USER%@*}/$DIR1"
DIR2_PATH="$SHOME/${USER%@*}/$DIR2"

# Check if directory exists, if not, create it
if [ ! -d "$DIR1_PATH"] && [! -d "$DIR2_PATH" ]; then
    mkdir -p "$DIR1_PATH"; mkdir -p "$DIR2_PATH"
    echo "Directory $DIR_PATH created."
else
    echo "Directory $DIR_PATH already exists."
fi
 #  symlink to be created

TARGET1="$SWORK/${USER%@*}/$DIR1"
SYMLINK1="$HOME/$DIR1"

TARGET2="$SSCRATCH/${USER%@*}/$DIR2"
SYMLINK2="$HOME/$DIR2"




# Check if the symlink already exists, if not, create it
if [ ! -L "$SYMLINK1"] && [ ! -L "$SYMLINK2" ]; then
  ln -s "$TARGET1" "$SYMLINK1" &&  ln -s "$TARGET2" "$SYMLINK2"
    echo "Symlink $SYMLINK created pointing to $TARGET."
else
    echo "Symlink $SYMLINK already exists."
fi
