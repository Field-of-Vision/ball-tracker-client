<p align="center">
<img src="tracker/data/fig/logoblack.png" alt="Logo">
</p>

<br />
<p align="center">
  <a href="https://github.com/Field-of-Vision">
    <img src="tracker/data/fig/fov_icon.png" alt="Logo" width="100" height="100">
  </a>

  <p align="center">
    Ball tracking desktop client.
    Sends the trajectory of the ball to AWS.
    This application is a placeholder which simmulates the image processing cameras.
  </p>
</p>

### Controls

* A - Pass
* D - Receive
* 1 - Ball out
* 2 - Home goal
* 3 - Away goal
* Hold left click - Home ball pocession
* Hold right click - Away ball pocession

### Dependencies

* [Processing](https://processing.org/)
* [websockets Processing Library](https://github.com/alexandrainst/processing_websockets)
* [ControlP5 Processing Library](https://github.com/sojamo/controlp5)

### Compilation
```sh
processing-java --sketch=<Project Directory>\tracker --export
```
