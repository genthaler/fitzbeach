module Robot.ModelTest exposing (tests)

import Expect
import Robot.Model exposing (Direction(..), Robot, facing, fromCoordinates, initialRobot, moveForward, turnLeft, turnRight, x, y)
import Test exposing (Test, describe, test)


tests : Test
tests =
    describe "Robot.Model"
        [ test "initialRobot starts at the origin facing north" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal 0 (x initialRobot)
                    , \_ -> Expect.equal 0 (y initialRobot)
                    , \_ -> Expect.equal North (facing initialRobot)
                    ]
                    ()
        , test "fromCoordinates rejects invalid positions" <|
            \_ ->
                Expect.all
                    [ \_ -> Expect.equal Nothing (fromCoordinates -1 0 North)
                    , \_ -> Expect.equal Nothing (fromCoordinates 0 5 North)
                    ]
                    ()
        , test "moveForward moves north by one cell" <|
            \_ ->
                assertRobot 2 3 North (moveForward (robot 2 2 North))
        , test "moveForward moves east by one cell" <|
            \_ ->
                assertRobot 3 2 East (moveForward (robot 2 2 East))
        , test "moveForward moves south by one cell" <|
            \_ ->
                assertRobot 2 1 South (moveForward (robot 2 2 South))
        , test "moveForward moves west by one cell" <|
            \_ ->
                assertRobot 1 2 West (moveForward (robot 2 2 West))
        , test "moveForward clamps at all board edges" <|
            \_ ->
                Expect.all
                    [ \_ ->
                        assertRobot 2 4 North (moveForward (robot 2 4 North))
                    , \_ ->
                        assertRobot 4 2 East (moveForward (robot 4 2 East))
                    , \_ ->
                        assertRobot 2 0 South (moveForward (robot 2 0 South))
                    , \_ ->
                        assertRobot 0 2 West (moveForward (robot 0 2 West))
                    ]
                    ()
        , test "turnLeft cycles through all directions" <|
            \_ ->
                Expect.equal
                    [ West, South, East, North ]
                    ([ robot 0 0 North
                     , robot 0 0 West
                     , robot 0 0 South
                     , robot 0 0 East
                     ]
                        |> List.map turnLeft
                        |> List.map facing
                    )
        , test "turnRight cycles through all directions" <|
            \_ ->
                Expect.equal
                    [ East, South, West, North ]
                    ([ robot 0 0 North
                     , robot 0 0 East
                     , robot 0 0 South
                     , robot 0 0 West
                     ]
                        |> List.map turnRight
                        |> List.map facing
                    )
        , test "turning never changes position" <|
            \_ ->
                let
                    positionedRobot : Robot
                    positionedRobot =
                        fromCoordinates 3 1 North
                            |> Maybe.withDefault initialRobot
                in
                Expect.all
                    [ \_ -> Expect.equal ( 3, 1 ) ( x (turnLeft positionedRobot), y (turnLeft positionedRobot) )
                    , \_ -> Expect.equal ( 3, 1 ) ( x (turnRight positionedRobot), y (turnRight positionedRobot) )
                    ]
                    ()
        , test "moving forward never changes facing" <|
            \_ ->
                Expect.equal
                    East
                    (facing (moveForward (robot 1 1 East)))
        ]


robot : Int -> Int -> Direction -> Robot
robot xCoordinate yCoordinate direction =
    fromCoordinates xCoordinate yCoordinate direction
        |> Maybe.withDefault initialRobot


assertRobot : Int -> Int -> Direction -> Robot -> Expect.Expectation
assertRobot expectedX expectedY expectedFacing actualRobot =
    Expect.all
        [ \_ -> Expect.equal expectedX (x actualRobot)
        , \_ -> Expect.equal expectedY (y actualRobot)
        , \_ -> Expect.equal expectedFacing (facing actualRobot)
        ]
        ()
