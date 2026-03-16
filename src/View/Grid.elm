module View.Grid exposing (board)

import Element exposing (Element, centerX, centerY, column, el, fill, height, none, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Robot
import View.Theme as Theme


board : Theme.Palette -> Robot.Robot -> Element msg
board colors robot =
    column
        [ centerX
        , spacing 18
        , Element.padding 24
        , Background.color colors.panelBackground
        , Border.width 1
        , Border.rounded 28
        , Border.color colors.panelBorder
        ]
        [ grid colors robot
        , el
            [ centerX
            , Font.size 13
            , Font.color colors.facingText
            ]
            (text ("Facing " ++ directionName (Robot.facing robot)))
        ]


grid : Theme.Palette -> Robot.Robot -> Element msg
grid colors robot =
    column
        [ centerX
        , spacing 10
        ]
        (List.map (gridRow colors robot) [ 4, 3, 2, 1, 0 ])


gridRow : Theme.Palette -> Robot.Robot -> Int -> Element msg
gridRow colors robot y =
    row [ spacing 10 ]
        (List.map (\x -> gridCell colors robot x y) [ 0, 1, 2, 3, 4 ])


gridCell : Theme.Palette -> Robot.Robot -> Int -> Int -> Element msg
gridCell colors robot x y =
    let
        isRobot =
            Robot.x robot == x && Robot.y robot == y
    in
    el
        [ width (px 68)
        , height (px 68)
        , Border.width 1
        , Border.rounded 14
        , Border.color
            (if isRobot then
                colors.robotAccent

             else
                colors.emptyCellBorder
            )
        , Background.color
            (if isRobot then
                colors.robotAccent

             else
                colors.emptyCellBackground
            )
        ]
        (if isRobot then
            robotMarker colors robot

         else
            none
        )


robotMarker : Theme.Palette -> Robot.Robot -> Element msg
robotMarker colors robot =
    el
        [ width fill
        , height fill
        , Element.padding 10
        ]
        (el
            [ width fill
            , height fill
            , Border.width 2
            , Border.rounded 999
            , Border.color colors.robotMarkerText
            ]
            (el
                [ centerX
                , centerY
                , Font.size 22
                , Font.color colors.robotMarkerText
                ]
                (text (directionSymbol (Robot.facing robot)))
            )
        )


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
