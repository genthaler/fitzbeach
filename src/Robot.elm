module Robot exposing (Direction(..), Robot, facing, fromCoordinates, initialRobot, moveForward, turnLeft, turnRight, x, y)


-- The four directions the robot can face on the grid.
type Direction
    = North
    | East
    | South
    | West


type Coordinate
    = Zero
    | One
    | Two
    | Three
    | Four


-- A robot position on a 5x5 grid, including its facing direction.
type Robot
    = Robot
        { x : Coordinate
        , y : Coordinate
        , facing : Direction
        }


-- The default starting position for the robot.
initialRobot : Robot
initialRobot =
    Robot
        { x = Zero
        , y = Zero
        , facing = North
        }


fromCoordinates : Int -> Int -> Direction -> Maybe Robot
fromCoordinates xCoordinate yCoordinate direction =
    Maybe.map2
        (\xValue yValue ->
            Robot
                { x = xValue
                , y = yValue
                , facing = direction
                }
        )
        (coordinateFromInt xCoordinate)
        (coordinateFromInt yCoordinate)


-- Move one step forward without ever leaving the 0..4 grid.
moveForward : Robot -> Robot
moveForward robot =
    case robot of
        Robot state ->
            case state.facing of
                North ->
                    Robot { state | y = increment state.y }

                East ->
                    Robot { state | x = increment state.x }

                South ->
                    Robot { state | y = decrement state.y }

                West ->
                    Robot { state | x = decrement state.x }


-- Rotate the robot 90 degrees counter-clockwise.
turnLeft : Robot -> Robot
turnLeft robot =
    case robot of
        Robot state ->
            Robot
                { state
                    | facing =
                        case state.facing of
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
    case robot of
        Robot state ->
            Robot
                { state
                    | facing =
                        case state.facing of
                            North ->
                                East

                            East ->
                                South

                            South ->
                                West

                            West ->
                                North
                }


x : Robot -> Int
x robot =
    case robot of
        Robot state ->
            coordinateToInt state.x


y : Robot -> Int
y robot =
    case robot of
        Robot state ->
            coordinateToInt state.y


facing : Robot -> Direction
facing robot =
    case robot of
        Robot state ->
            state.facing


coordinateFromInt : Int -> Maybe Coordinate
coordinateFromInt value =
    case value of
        0 ->
            Just Zero

        1 ->
            Just One

        2 ->
            Just Two

        3 ->
            Just Three

        4 ->
            Just Four

        _ ->
            Nothing


coordinateToInt : Coordinate -> Int
coordinateToInt coordinate =
    case coordinate of
        Zero ->
            0

        One ->
            1

        Two ->
            2

        Three ->
            3

        Four ->
            4


increment : Coordinate -> Coordinate
increment coordinate =
    case coordinate of
        Zero ->
            One

        One ->
            Two

        Two ->
            Three

        Three ->
            Four

        Four ->
            Four


decrement : Coordinate -> Coordinate
decrement coordinate =
    case coordinate of
        Zero ->
            Zero

        One ->
            Zero

        Two ->
            One

        Three ->
            Two

        Four ->
            Three
