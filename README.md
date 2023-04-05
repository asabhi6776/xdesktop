
# lDesktop

lDesktop is a VDI solution which runs Ubuntu GUI in docker containing all the required tools fro java and python development.

## Usage/Examples

```bash
git clone git@gitlab.bangalore2.com:tech/ldesktop.git
cd ldesktop
docker run -it -d --privileged -p 6080:6080 gitlabe.bangalore2.com/tech/ldesktop:latest
```


## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`VNC_PW`

`USERNAME`


## Features

- Lightweight VDI solution
- It will run in Docker no need to assign heavy VMs
- Preinstalled VSCode, Firefox and Other Usefull Applications
- ARM64/AMD64


## Contributing

Contributions are always welcome!



## Authors

- [@asabhi6776](https://www.github.com/asabhi6776)


## License

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

