module Robot exposing (Direction(..), Robot, initialRobot, moveForward, turnLeft, turnRight)


-- The four directions the robot can face on the grid.
type Direction
    = North
    | East
    | South
    | West


-- A robot position on a 5x5 grid, including its facing direction.
type alias Robot =
    { x : Int
    , y : Int
    , facing : Direction
    }


-- The default starting position for the robot.
initialRobot : Robot
initialRobot =
    { x = 0
    , y = 0
    , facing = North
    }


-- Move one step forward without ever leaving the 0..4 grid.
moveForward : Robot -> Robot
moveForward robot =
    case robot.facing of
        North ->
            { robot | y = clampToGrid (robot.y + 1) }

        East ->
            { robot | x = clampToGrid (robot.x + 1) }

        South ->
            { robot | y = clampToGrid (robot.y - 1) }

        West ->
            { robot | x = clampToGrid (robot.x - 1) }


-- Rotate the robot 90 degrees counter-clockwise.
turnLeft : Robot -> Robot
turnLeft robot =
    { robot
        | facing =
            case robot.facing of
                North ->
                    West

                West ->
                    South

                South ->
                    East

                East ->
                    North
    }


-- Rotate the robot 90 degrees clockwise.
turnRight : Robot -> Robot
turnRight robot =
    { robot
        | facing =
            case robot.facing of
                North ->
                    East

                East ->
                    South

                South ->
                    West

                West ->
                    North
    }


-- Clamp a coordinate so it always stays inside the 5x5 board.
clampToGrid : Int -> Int
clampToGrid value =
    clamp 0 4 value
