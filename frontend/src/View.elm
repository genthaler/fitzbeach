module View exposing (Page(..), page)

import Element exposing (Element)
import Motorcycle.Model as Motorcycle
import Motorcycle.View
import Robot
import Robot.View
import ServiceHealth
import View.Theme as Theme


type Page
    = MotorcyclePage
    | RobotPage


page :
    { a
        | serviceHealth : ServiceHealth.ServiceHealth
        , motorcycleProducts : Motorcycle.ProductState
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
            Motorcycle.View.view
                compactLayout
                colors
                model.serviceHealth
                model.motorcycleProducts

        RobotPage ->
            Robot.View.view compactLayout colors model.robot robotControls
