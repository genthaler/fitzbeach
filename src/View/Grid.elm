module View.Grid exposing (board)

import Element exposing (Element, centerX, centerY, column, el, fill, height, none, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Robot
import View.Theme as Theme


board : Robot.Robot -> Element msg
board robot =
    column
        [ centerX
        , spacing 18
        , Element.padding 24
        , Background.color Theme.panelBackground
        , Border.width 1
        , Border.rounded 28
        , Border.color Theme.panelBorder
        ]
        [ grid robot
        , el
            [ centerX
            , Font.size 13
            , Font.color Theme.facingText
            ]
            (text ("Facing " ++ directionName robot.facing))
        ]


grid : Robot.Robot -> Element msg
grid robot =
    column
        [ centerX
        , spacing 10
        ]
        (List.map (gridRow robot) [ 4, 3, 2, 1, 0 ])


gridRow : Robot.Robot -> Int -> Element msg
gridRow robot y =
    row [ spacing 10 ]
        (List.map (\x -> gridCell robot x y) [ 0, 1, 2, 3, 4 ])


gridCell : Robot.Robot -> Int -> Int -> Element msg
gridCell robot x y =
    let
        isRobot =
            robot.x == x && robot.y == y
    in
    el
        [ width (px 68)
        , height (px 68)
        , Border.width 1
        , Border.rounded 14
        , Border.color
            (if isRobot then
                Theme.robotAccent

             else
                Theme.emptyCellBorder
            )
        , Background.color
            (if isRobot then
                Theme.robotAccent

             else
                Theme.emptyCellBackground
            )
        ]
        (if isRobot then
            robotMarker robot

         else
            none
        )


robotMarker : Robot.Robot -> Element msg
robotMarker robot =
    column
        [ width fill
        , height fill
        , centerX
        , centerY
        , spacing 4
        ]
        [ el [ centerX, Font.size 24, Font.color Theme.robotMarkerText ] (text (directionSymbol robot.facing))
        , el [ centerX, Font.size 11, Font.color Theme.robotSubtleText ] (text "ROBOT")
        ]


directionSymbol : Robot.Direction -> String
directionSymbol direction =
    case direction of
        Robot.North ->
            "↑"

        Robot.East ->
            "→"

        Robot.South ->
            "↓"

        Robot.West ->
            "←"


directionName : Robot.Direction -> String
directionName direction =
    case direction of
        Robot.North ->
            "North"

        Robot.East ->
            "East"

        Robot.South ->
            "South"

        Robot.West ->
            "West"
