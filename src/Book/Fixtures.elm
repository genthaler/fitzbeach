module Book.Fixtures exposing
    ( RobotDemo
    , initialRobotDemo
    )

import Robot.Logic as RobotLogic
import Robot.Model as Robot


type alias RobotDemo =
    { robot : Robot.Robot
    , history : List RobotLogic.HistoryEntry
    }


initialRobotDemo : RobotDemo
initialRobotDemo =
    { robot = Robot.initialRobot
    , history = []
    }
