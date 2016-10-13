import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import List
import String

{-

an accounts field, that represents each account,  of type Account, which is a
list of transactions and a starting balance The # of transactions kept in the
model is limited, for performance reasons. The source of truth for transaction
data is the bank account, not the app The starting balance is essentially an
accumulator on data that needs to be cleaned out at the tail of the list

The transaction data type is an amount (positive or negative), datetime, the
payee, reason, and a notes field, which just captures any other notes from the
transaction.

The other fields are Name and AccountType

The User type is for the person that is logged into the app

The ScrapeIO type is what gets returned from pulls from institutions

The Payee type represents you are giving money to. It's just a name, a
category, and notes

-}

main =
        App.beginnerProgram { model = model, view = view, update = update }

-- MODEL

type alias Model = List Transaction


type alias Account =
        { name : String
        , kind : AccountKind
        , transactions : List Transaction
        , balance : Int
        }

type alias Transaction =
        { amount : String
        --, datetime : DateTime
        , payee : String
        , notes : String
        }

type AccountKind = Checking | Savings | CreditCard
type ScrapeIO = NotSent | Waiting | Success | Failure

model : Model
model =
        []

blankAccount : { account : Account, user: String }
blankAccount =
        { account = Account "Checking" Checking [] 0
        , user = "Sam"
        }


-- UPDATE

type Msg msg = AddTransaction msg | EditTransaction msg | ResetTransaction

update : Msg Transaction -> Model -> Model
update msg model =
        case msg of
                AddTransaction transaction ->
                        transaction :: model
                EditTransaction transaction ->
                        
                ResetTransaction ->
                        []

-- VIEW

view : Model -> Html msg
view model =
        div []
                [ viewTransactions model
                , viewAddTransaction model
                ]

viewTransactions : Model -> Html msg
viewTransactions transactions =
        table []
                [ thead []
                        [ th [] [text "Payee"]
                        , th [] [text "Amount"]
                        , th [] [text "Notes"]
                        ]
                , tbody [] <| List.map (viewTransactionRow) transactions
                ]

viewTransactionRow : Transaction -> Html msg
viewTransactionRow transaction =
        tr []
                [ td [] [text transaction.payee]
                , td [] [text transaction.amount]
                , td [] [text transaction.notes]
                ]

viewAddTransaction : Model -> Html msg
vewAddTransaction model =
        form []
                [ input [ type' "text", placeholder "Payee", onInput  
                ]
