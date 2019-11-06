# Smart Promo Api - ALPHA

API  to improve the customer experience managing promotions like a loyalty card, sweepstakes, and benefits club.
This application runs with Ruby + Graphql


* Ruby version
```
2.6.0
```
  
* Please make the code always better
```
rubocop -a
```

* Database creation
```
Usual rails flow
```

* To run the test suit
just run `rspec`


## Mutation exemples

There are all mutation/queries examples on `spec/graphql`.
Some of them bellow:

### On your landing page

Mutation to create tickets:
  ```graphql
    mutation ($cellphoneNumber: String!, $quantity: Int!, $promotionId: Int) {
      createTickets(cellphoneNumber: $cellphoneNumber, quantity: $quantity, promotionId: $promotionId) {
       success
     }
   }
  ```
  
### On Costumer dashboard
 
Login
 
 ```graphql
   mutation login($login: String!, $password: String!) {
     createSession(login: $login, password: $password) {
       authToken
      }
   }
 ```
 
Mutation to create promotion:
  ```graphql
  mutation createPromotion($name: String!, $cost: Int!, $goalQuantity: Int!, $promotionTypeId: Int!, $description: String!, $startDatetime: String!, $endDatetime: String!, $highlighted: Boolean, $active: Boolean) {
    createPromotion(name: $name, promotionTypeId: $promotionTypeId, cost: $cost, goalQuantity: $goalQuantity, description: $description, startDatetime: $startDatetime, endDatetime: $endDatetime, highlighted: $highlighted, active: $active) {
      promotion {
        id
        name
        description
        startDatetime
        endDatetime
        active
        highlighted
        cost
        goalQuantity
        promotionType {
          id
          label
        }
      }
    }
  }
 ```
