# CLI Tools

A mixed bag of handy bash functions. Load them up with

```sh
  $ source functions.sh
```

### DISCLAIMER
>
>
> No attempt has been made for POSIX-compliance or even backwards compatibility
> with old bash versions. However, none of the functions depends on programs
> not found in a typical \*NIX installation.

> Some of the functions I've written, some I have adapted from others' work and
> some I have copied verbatim. References are given where appropriate.
>

### Showcase

* Testing that REST API

```sh
   for i in tests/*.json; do
      post_json "$i" http://api.example.com/foo/bar
   done
```

* Information about your Internet Service Provider
```sh
  $ whois $(myip -p)
```

* Load a bunch of files in parallel, quoting each url

```sh
  $ parallel_download $(quote_it < urls.lst)
```

* Which URLs are not accessible, i.e., have a status code greater than or equal to 400?

```sh
  while read url; do
    http_status $url
  done < url.lst | awk '$1 >= 400'
```

* How big is style.css when compressed and how much HTML do we ship?

```sh
  $ sizeof -g < style.css
  $ curl http://www.example.com | sizeof
```

* Make sshfs (https://github.com/libfuse/sshfs) mount everything automatically under ~/Remote

```sh
  # The remote folder /home/dev/project_x will be mounted under ~/Remote/dev.server.com_project_x
  sshfs dev.server.com:/home/dev/project_x
```

* List all active SSH connections
```sh
  lsssh
```

* A git-aware bash prompt (requires an emoji font to be installed on your machine)
```sh
export PS1="$(git_prompt)"
```

* Which npm package has the dependency foobar?
```sh
npm ls | highlight foobar
```
