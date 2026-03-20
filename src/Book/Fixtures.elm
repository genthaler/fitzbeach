module Book.Fixtures exposing
    ( RobotDemo
    , initialRobotDemo
    )

import Robot.Feature


type alias RobotDemo =
    Robot.Feature.Model


initialRobotDemo : RobotDemo
initialRobotDemo =
    Robot.Feature.initialModel
