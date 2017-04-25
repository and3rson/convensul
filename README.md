# Convensul

A lightweight bash version of the "envconsul" utility.

# Dependencies

- Core utils (`curl`, `awk` and `cut`)

# Usage

Imaging you have this kind of document in Consul KV storage:

```yaml
# KV: /config/app
FOO: bar
SPAM: eggs
```

Let's create a simple Python app that uses env variables:

```python
# application.py
import os

print('Foo is %s.' % os.environ['FOO'])
print('Spam is best served with %s.' % os.environ['SPAM'])
```

Now let's run `convensul`:

```bash
$ convensul.sh 127.0.0.1:8500 secret-acl-token /config/app python application.py
Foo is bar.
Spam is best server with eggs.
```

You can also store the ACL token in the environment if you don't want to expose its value,
for example, if your script is used in some sort of CI, e. g. Jenkins.

For this you need to set CONVENSUL_TOKEN env var to your token value and pass `-` instead of the token:

```bash
$ export CONVENSUL_TOKEN=secret-acl-token
$ convensul.sh 127.0.0.1:8500 - /config/app python application.py
Foo is bar.
Spam is best server with eggs.
```

# Why "convensul"?

Because "convensul" is a mix of "consul" and "env": "conVENsul".

Also it has some sort of "convention" word meaning.
