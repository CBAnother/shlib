# 下载 lib

## 常规

```
SCRIPT_NAME="elib.sh"
TIMEOUT=1
LOCAL_DIR="$HOME/.local/elib"
LOCAL_PATH="$LOCAL_DIR/$SCRIPT_NAME"

if [ ! -f "$LOCAL_PATH" ]; then
    source <(curl -fsSL https://raw.githubusercontent.com/CBAnother/shlib/refs/heads/main/$SCRIPT_NAME) 
else
    source "$LOCAL_PATH"
fi
```



## 国内

```
SCRIPT_NAME="elib.sh"
TIMEOUT=1
LOCAL_DIR="$HOME/.local/elib"
LOCAL_PATH="$LOCAL_DIR/$SCRIPT_NAME"

if [ ! -f "$LOCAL_PATH" ]; then
    source <(curl -fsSL https://gitee.com/wwwmwwwmwwwmwwwm/shlib/raw/main/$SCRIPT_NAME) 
else
    source "$LOCAL_PATH"
fi
```

