module View exposing (Page(..), page, themeToggleDescription, toggleThemeMode)

import Element exposing (Element)
import Motorcycle
import Motorcycle.Model as Motorcycle
import Robot
import Robot.View
import View.Theme as Theme
import View.ThemeToggle as ThemeToggle


type Page
    = MotorcyclePage
    | RobotPage


page :
    { a
        | motorcycleProducts : Motorcycle.ProductState
        , robot : Robot.Model
        , currentPage : Page
    }
    -> Theme.Palette
    -> Bool
    -> Robot.View.Controls msg
    -> Element msg
page model colors compactLayout robotControls =
    case model.currentPage of
        MotorcyclePage ->
            Motorcycle.view
                compactLayout
                colors
                model.motorcycleProducts

        RobotPage ->
            Robot.View.view compactLayout colors model.robot robotControls


toggleThemeMode : Theme.Mode -> Theme.Mode
toggleThemeMode =
    ThemeToggle.toggleThemeMode


themeToggleDescription : Theme.Mode -> String
themeToggleDescription =
    ThemeToggle.themeToggleDescription
