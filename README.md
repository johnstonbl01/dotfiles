# Setup new mac and project dot files

## Testing (Docker)

```bash
docker build ./setup/Dockerfile -t dotfiles
docker run -it --rm -v ${PWD}/setup:/usr/local/bin dotifles bash

ansible-playbook --ask-become-pass setup.yml
```
