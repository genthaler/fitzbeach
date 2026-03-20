module Book.Fixtures exposing
    ( RobotDemo
    , initialRobotDemo
    )

import Robot


type alias RobotDemo =
    Robot.Model


initialRobotDemo : RobotDemo
initialRobotDemo =
    Robot.initialModel
