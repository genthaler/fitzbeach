module RobotTest exposing (tests)

import Expect
import Robot exposing (Direction(..), Robot, initialRobot, moveForward, turnLeft, turnRight)
import Test exposing (Test, describe, test)


tests : Test
tests =
    describe "Robot"
        [ test "initialRobot starts at the origin facing north" <|
            \_ ->
                Expect.equal
                    { x = 0, y = 0, facing = North }
                    initialRobot
        , test "moveForward moves north by one cell" <|
            \_ ->
                Expect.equal
                    { x = 2, y = 3, facing = North }
                    (moveForward { x = 2, y = 2, facing = North })
        , test "moveForward moves east by one cell" <|
            \_ ->
                Expect.equal
                    { x = 3, y = 2, facing = East }
                    (moveForward { x = 2, y = 2, facing = East })
        , test "moveForward moves south by one cell" <|
            \_ ->
                Expect.equal
                    { x = 2, y = 1, facing = South }
                    (moveForward { x = 2, y = 2, facing = South })
        , test "moveForward moves west by one cell" <|
            \_ ->
                Expect.equal
                    { x = 1, y = 2, facing = West }
                    (moveForward { x = 2, y = 2, facing = West })
        , test "moveForward clamps at all board edges" <|
            \_ ->
                Expect.all
                    [ \_ ->
                        Expect.equal
                            { x = 2, y = 4, facing = North }
                            (moveForward { x = 2, y = 4, facing = North })
                    , \_ ->
                        Expect.equal
                            { x = 4, y = 2, facing = East }
                            (moveForward { x = 4, y = 2, facing = East })
                    , \_ ->
                        Expect.equal
                            { x = 2, y = 0, facing = South }
                            (moveForward { x = 2, y = 0, facing = South })
                    , \_ ->
                        Expect.equal
                            { x = 0, y = 2, facing = West }
                            (moveForward { x = 0, y = 2, facing = West })
                    ]
                    ()
        , test "turnLeft cycles through all directions" <|
            \_ ->
                Expect.equal
                    [ West, South, East, North ]
                    ([ { x = 0, y = 0, facing = North }
                     , { x = 0, y = 0, facing = West }
                     , { x = 0, y = 0, facing = South }
                     , { x = 0, y = 0, facing = East }
                     ]
                        |> List.map turnLeft
                        |> List.map .facing
                    )
        , test "turnRight cycles through all directions" <|
            \_ ->
                Expect.equal
                    [ East, South, West, North ]
                    ([ { x = 0, y = 0, facing = North }
                     , { x = 0, y = 0, facing = East }
                     , { x = 0, y = 0, facing = South }
                     , { x = 0, y = 0, facing = West }
                     ]
                        |> List.map turnRight
                        |> List.map .facing
                    )
        , test "turning never changes position" <|
            \_ ->
                let
                    robot : Robot
                    robot =
                        { x = 3, y = 1, facing = North }
                in
                Expect.all
                    [ \_ -> Expect.equal ( 3, 1 ) ( (turnLeft robot).x, (turnLeft robot).y )
                    , \_ -> Expect.equal ( 3, 1 ) ( (turnRight robot).x, (turnRight robot).y )
                    ]
                    ()
        , test "moving forward never changes facing" <|
            \_ ->
                Expect.equal
                    East
                    ((moveForward { x = 1, y = 1, facing = East }).facing)
        ]
