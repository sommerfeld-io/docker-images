Output ls.gif

Set FontSize 16
Set Width 820
Set Height 400

Type "docker run --rm -v $(pwd):$(pwd) -w $(pwd) alpine:latest pwd"
Sleep 500ms
Enter
Sleep 2s

Type "docker run --rm -v $(pwd):$(pwd) -w $(pwd) alpine:latest ls"
Sleep 500ms
Enter
Sleep 8s
