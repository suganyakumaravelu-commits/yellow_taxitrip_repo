erDiagram



&#x20;   FACT\_TRIP {

&#x20;       timestamp pickup\_ts

&#x20;       date pickup\_date

&#x20;       int pickup\_hour

&#x20;       int vendorid

&#x20;       int passenger\_count

&#x20;       float trip\_distance

&#x20;       float fare\_amount

&#x20;       float tip\_amount

&#x20;       float total\_amount

&#x20;       int trip\_duration\_minutes

&#x20;       int pu\_zone\_id

&#x20;       int do\_zone\_id

&#x20;       int payment\_type

&#x20;   }



&#x20;   DIM\_ZONE {

&#x20;       int zone\_id

&#x20;       string zone

&#x20;       string borough

&#x20;   }



&#x20;   DIM\_DATE {

&#x20;       date date

&#x20;       int year

&#x20;       int month

&#x20;       int day

&#x20;       int day\_of\_week

&#x20;       boolean is\_weekend

&#x20;   }



&#x20;   %% Relationships

&#x20;   FACT\_TRIP ||--o{ DIM\_ZONE : "pu\_zone\_id → zone\_id"

&#x20;   FACT\_TRIP ||--o{ DIM\_ZONE : "do\_zone\_id → zone\_id"

&#x20;   FACT\_TRIP }o--|| DIM\_DATE : "pickup\_date → date"



