# ELK image on Scaleway [5.1.2]

Updating the Image on your server: 

- Make updates to image, `commit`, `push`.

```sh
$ brew tap scaleway/scaleway
$ brew install scaleway/scaleway/scw --HEAD
$ scw login # enter your credentials
$ scw run --name="elasticstack" image-builder
```

- Wait a few minutes. Check status in your Scaleway console.
- When booted, you're at the prompt of your image, directly on a Scaleway machine.
- Login again

```sh
$ scw login # credentials again
git clone YOUR_REPO
cd YOUR_REPO
make image_on_local
```

Custom image is now available here: https://cloud.scaleway.com/#/images
Based on instructions here: https://github.com/scaleway/image-builder
