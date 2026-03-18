module Robot.View exposing (Controls, page)

import Element exposing (Element, alpha, centerX, centerY, column, el, fill, height, maximum, none, paddingXY, px, row, spacing, text, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as HtmlAttributes
import Robot.Logic as Logic
import Robot.Model as Robot
import View.Theme as Theme


type alias Controls msg =
    { moveForward : msg
    , turnLeft : msg
    , turnRight : msg
    , undo : msg
    , reset : msg
    }


page :
    Bool
    -> Theme.Palette
    -> { a | robot : Robot.Robot, history : List Logic.HistoryEntry }
    -> Controls msg
    -> Element msg
page compactLayout colors model controls =
    column
        [ width fill
        , spacing 28
        , Element.paddingEach { top = 24, right = 0, bottom = 0, left = 0 }
        ]
        [ pageHeading compactLayout colors "Robot"
        , board compactLayout colors model.robot
        , controlRow colors model.robot controls
        , commandHistory colors (List.map .command model.history)
        ]


pageHeading : Bool -> Theme.Palette -> String -> Element msg
pageHeading compactLayout colors labelText =
    column
        [ width fill
        , spacing 8
        ]
        [ el
            [ Font.size
                (if compactLayout then
                    30

                 else
                    36
                )
            ]
            (text labelText)
        , el
            [ width fill
            , height (px 1)
            , Background.color colors.panelBorder
            ]
            none
        ]


board : Bool -> Theme.Palette -> Robot.Robot -> Element msg
board compactLayout colors robot =
    column
        [ centerX
        , spacing 18
        , Element.padding
            (if compactLayout then
                16

             else
                24
            )
        , Background.color colors.panelBackground
        , Border.width 1
        , Border.rounded 28
        , Border.color colors.panelBorder
        ]
        [ grid compactLayout colors robot
        , el
            [ centerX
            , Font.size 13
            , Font.color colors.facingText
            ]
            (text ("Facing " ++ directionName (Robot.facing robot)))
        ]


grid : Bool -> Theme.Palette -> Robot.Robot -> Element msg
grid compactLayout colors robot =
    column
        [ centerX
        , spacing
            (if compactLayout then
                8

             else
                10
            )
        ]
        (List.map (gridRow compactLayout colors robot) [ 4, 3, 2, 1, 0 ])


gridRow : Bool -> Theme.Palette -> Robot.Robot -> Int -> Element msg
gridRow compactLayout colors robot yCoordinate =
    row
        [ spacing
            (if compactLayout then
                8

             else
                10
            )
        ]
        (List.map (\xCoordinate -> gridCell compactLayout colors robot xCoordinate yCoordinate) [ 0, 1, 2, 3, 4 ])


gridCell : Bool -> Theme.Palette -> Robot.Robot -> Int -> Int -> Element msg
gridCell compactLayout colors robot xCoordinate yCoordinate =
    let
        isRobot =
            Robot.x robot == xCoordinate && Robot.y robot == yCoordinate

        cellSize =
            if compactLayout then
                48

            else
                68
    in
    el
        [ width (px cellSize)
        , height (px cellSize)
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
            robotMarker compactLayout colors robot

         else
            none
        )


robotMarker : Bool -> Theme.Palette -> Robot.Robot -> Element msg
robotMarker compactLayout colors robot =
    el
        [ width fill
        , height fill
        , Element.padding
            (if compactLayout then
                8

             else
                10
            )
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
                , Font.size
                    (if compactLayout then
                        18

                     else
                        22
                    )
                , Font.color colors.robotMarkerText
                ]
                (text (directionSymbol (Robot.facing robot)))
            )
        )


controlRow : Theme.Palette -> Robot.Robot -> Controls msg -> Element msg
controlRow colors robot controls =
    wrappedRow
        [ centerX
        , spacing 12
        ]
        [ controlButton colors
            "Move Forward"
            (if Logic.canApplyCommand Logic.MoveForwardCommand robot then
                Just controls.moveForward

             else
                Nothing
            )
        , controlButton colors "Turn Left" (Just controls.turnLeft)
        , controlButton colors "Turn Right" (Just controls.turnRight)
        , controlButton colors "Undo" (Just controls.undo)
        , controlButton colors "Reset" (Just controls.reset)
        ]


controlButton : Theme.Palette -> String -> Maybe msg -> Element msg
controlButton colors labelText onPress =
    Input.button
        (case onPress of
            Just _ ->
                [ Background.color colors.buttonBackground
                , Border.rounded 16
                , Border.width 1
                , Border.color colors.buttonBorder
                , paddingXY 18 12
                , Font.size 14
                , Font.color colors.buttonText
                ]

            Nothing ->
                [ Background.color colors.buttonBackground
                , Border.rounded 16
                , Border.width 1
                , Border.color colors.buttonBorder
                , paddingXY 18 12
                , Font.size 14
                , Font.color colors.detailText
                , alpha 0.65
                , Element.htmlAttribute (HtmlAttributes.disabled True)
                ]
        )
        { onPress = onPress
        , label = text labelText
        }


commandHistory : Theme.Palette -> List Logic.Command -> Element msg
commandHistory colors history =
    column
        [ width (maximum 340 fill)
        , centerX
        , spacing 10
        ]
        [ el [ Font.size 14, Font.color colors.detailText ] (text "Command History")
        , case history of
            latest :: rest ->
                column
                    [ width fill
                    , spacing 8
                    ]
                    (historyItem colors True latest :: List.map (historyItem colors False) (List.take 5 rest))

            [] ->
                el
                    [ width fill
                    , Background.color colors.buttonBackground
                    , Border.rounded 16
                    , Border.width 1
                    , Border.color colors.buttonBorder
                    , paddingXY 18 12
                    , Font.size 14
                    , Font.color colors.buttonText
                    ]
                    (text "No commands yet")
        ]


historyItem : Theme.Palette -> Bool -> Logic.Command -> Element msg
historyItem colors isLatest command =
    el
        [ width fill
        , Background.color colors.buttonBackground
        , Border.rounded 16
        , Border.width 1
        , Border.color colors.buttonBorder
        , paddingXY 18 12
        , Font.size 14
        , Font.color colors.buttonText
        ]
        (text
            (if isLatest then
                "Latest: " ++ Logic.label command

             else
                Logic.label command
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
