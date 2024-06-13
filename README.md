# 🐙 Dotfiles Docker Image

This Docker image provides a convenient way to manage and use dotfiles in a Dockerized environment. It includes configurations for commonly used files like `.config`, `.gitconfig`, `.gitignore`, `.czrc`, and `.scripts`.

## 🪴 Usage

### 🚀 Quick Start

To get started, run the following command:

```bash
docker run -it --rm -v $HOME:/pungrumpy -w /pungrumpy ghcr.io/pungrumpy/dotfiles:latest
```

### 📦 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your machine.

### 🛠️ Building the Image

To build the image, run the following command:

```bash
docker buildx build -t ghcr.io/pungrumpy/dotfiles:latest . --build-arg UBUNTU_VERSION=24.04 --build-arg USERNAME=$(whoami)
```

### 🧪 Running the Image

To run the image, run the following command:

```bash
docker run -it --rm --name dotfiles \
  -v $HOME/.config:/home/pungrumpy/.config \
  -v $HOME/.gitconfig:/home/pungrumpy/.gitconfig \
  -v $HOME/.gitignore:/home/pungrumpy/.gitignore \
  -v $HOME/.czrc:/home/pungrumpy/.czrc \
  -v $HOME/.scripts:/home/pungrumpy/.scripts \
  ghcr.io/pungrumpy/dotfiles:latest
```

### 🧹 Cleaning Up

To clean up, run the following command:

```bash
docker rmi ghcr.io/pungrumpy/dotfiles:latest
```

### 📝 Notes

- Ensure that the dotfiles you want to use are present in the corresponding directories on your local system (`$HOME/.config`, `$HOME/.gitconfig`, etc.).
- Replace `ghcr.io/pungrumpy/dotfiles:latest` with the actual image name and tag if you have customized your Docker image.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
