import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Date exposing (Date)
import Array
import String

{-

payday budget type, which is the principal model in this app. It init's from
data from the bank or CU with the balance of an account after a payday. The
budget items are Transactions that either have happened, or haven't
happened yet.

The transaction data type is an amount (positive or negative), datetime, the
payee, reason, and a notes field, which just captures any other notes from the
transaction. Typically, these are going to be credits, since the record keeping
only persists between paydays. But I want to include unexpected windfalls as
valid inputs

The Payee type represents you are giving money to. It's just a name, a
category, and notes

-}

main =
        App.beginnerProgram { model = model, view = view, update = update }

-- MODEL

type alias Model =
        { finishDate : Date
        , startingBalance : Int
        , transactions : Array Transaction
        }

type alias Transaction =
        { datetime : Date
        , amount : Int
        , notes : String
        }

model : Model
model =
        Model Date.now 0 Array.empty

initBudget : Date -> Int -> Date -> Model
initBudget endDate startBalance =
    Model endDate startBalance Array.empty

-- UPDATE

type Msg msg
        = AddTransaction msg
        | EditTransaction msg
        | ResetTransaction

update : Msg Transaction -> Model -> Model
update msg model =
        case msg of
                AddTransaction transaction ->
                        Array.push transaction model
                EditTransaction transaction ->
                        editTransaction transaction model
                ResetTransaction ->
                        Array.empty

editTransaction : Transaction -> Model -> Model
editTransaction transaction model =
        let
            (subject, rest) = head model
            equal = subject.datetime == transaction.datetime
        in
            case equal of
                    True ->
                            transaction :: rest
                    False ->
                            (::) subject <| editTransaction transaction rest

-- VIEW

view : Model -> Html msg
view model =
        div []
                [ viewTransactions model
                , viewAddTransaction
                ]

viewTransactions : Model -> Html msg
viewTransactions transactions =
        table []
                [ thead []
                        [ th [] [text "Time"]
                        , th [] [text "Amount"]
                        , th [] [text "Notes"]
                        ]
                , tbody [] <| List.map (viewTransactionRow) transactions
                ]

viewTransactionRow : Transaction -> Html msg
viewTransactionRow transaction =
        tr []
                [ td [] [text transaction.datetime]
                , td [] [text transaction.amount]
                , td [] [text transaction.notes]
                ]

viewAddTransaction : Html msg
vewAddTransaction =
        form []
                [ input [ type' "text", placeholder "Payee", onInput
                ]

