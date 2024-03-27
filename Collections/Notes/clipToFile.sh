#!/usr/bin/sh

# clipToFile.sh
# save the contents of the clipboard to a file

CLIPMAN=$( \
  command -v xclip >/dev/null && \
  echo "xclip" || \
  echo "none"
)

[[ $CLIPMAN == "none" ]] && \
CLIPMAN=$( \
  command -v xsel >/dev/null && \
  echo "xsel" || echo "none"
)

[[ $CLIPMAN == "none" ]] && \
echo "No clipboard manager found" && \
unset CLIPMAN && \
exit 1

# get the clipboard contents
CONTENT=$( $CLIPMAN -o )

[[ -z $CONTENT ]] && \
echo "Clipboard is empty" && \
unset CLIPMAN CONTENT && \
exit 1

# get the file name from arg1 if it was given
[[ -n $1 ]] && \
FILENAME=$1 || \
FILENAME=""

# if no file name was given, check $CLIP_FILE
[[ -z $FILENAME ]] && \
[[ -n $CLIP_FILE ]] && \
FILENAME=$CLIP_FILE

# if env var was not set, check for $XDG_DOCUMENTS_DIR
[[ -z $FILENAME ]] && \
[[ -n $XDG_DOCUMENTS_DIR ]] && \
FILENAME="$XDG_DOCUMENTS_DIR/clipboardSaves"

# if $XDG_DOCUMENTS_DIR is not set, use the default value for  $XDG_DOCUMENTS_DIR
[[ -z $FILENAME ]] && \
FILENAME="$HOME/Documents/clipboardSaves"

# if the file already exists, append the clipboard contents to it
[[ -f $FILENAME ]] && \
echo "" >> $FILENAME && \
echo "#####  $(date)  #####" >> $FILENAME && \
echo "" >> $FILENAME && \
echo "$CONTENT" >> $FILENAME && \
echo "#####################" >> $FILENAME && \
echo "Appended to $FILENAME" && \
unset CLIPMAN CONTENT FILENAME && \
exit 0

# if the file does not exist, create it and write the clipboard contents to it
echo "$CONTENT" > $FILENAME && \
echo "Saved to $FILENAME" && \
unset CLIPMAN CONTENT FILENAME && \
exit 0
