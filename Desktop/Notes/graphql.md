# Queries And Mutations

## Fields

Fields are the data attributes defined in your object / database.

input:

```  							
{
  hero {
    name
    # Queries can have comments!
    friends {
      name
    }
  }
}

```

output:

```

{
  "data": {
    "hero": {
      "name": "R2-D2",
      "friends": [
        {
          "name": "Luke Skywalker"
        },
        {
          "name": "Han Solo"
        },
        {
          "name": "Leia Organa"
        }
      ]
    }
  }
}

```

## Arguments

We can pass arguments to fields to get the specefic data we want

input:

```
{
  human(id: "1000") {
    name
    height(unit: FOOT)
  }
}
```

output:

```
{
  "data": {
    "human": {
      "name": "Luke Skywalker",
      "height": 5.6430448
    }
  }
}
```
Arguments can be of many different types. GraphQL comes with a default set of types, but a GraphQL server can also declare its own custom types.

## Aliases

input:

```
{
  empireHero: hero(episode: EMPIRE) {
    name
  }
  jediHero: hero(episode: JEDI) {
    name
  }
}
```

output:

```
{
  "data": {
    "empireHero": {
      "name": "Luke Skywalker"
    },
    "jediHero": {
      "name": "R2-D2"
    }
  }
}
```

## Fragments

GraphQL includes reusable units called fragments.

input:

```
{
  leftComparison: hero(episode: EMPIRE) {
    ...comparisonFields
  }
  rightComparison: hero(episode: JEDI) {
    ...comparisonFields
  }
}

fragment comparisonFields on Character {
  name
  appearsIn
  friends {
    name
  }
}
```
output: 

```

{
  "data": {
    "leftComparison": {
      "name": "Luke Skywalker",
      "appearsIn": [
        "NEWHOPE",
        "EMPIRE",
        "JEDI"
      ],
      "friends": [
        {
          "name": "Han Solo"
        },
        {
          "name": "Leia Organa"
        },
      ]
    },
    "rightComparison": {
      "name": "R2-D2",
      "appearsIn": [
        "NEWHOPE",
        "EMPIRE",
        "JEDI"
      ],
      "friends": [
        {
          "name": "Luke Skywalker"
        },
        {
          "name": "Han Solo"
        },
      ]
    }
  }
}
```


### Inline Fragments

Query:

```
{
  hero {
    name
    ... on Droid {
      primaryFunction
    }
  }
}
```
output:

```
{
  "data": {
    "hero": {
      "name": "R2-D2",
      "primaryFunction": "Astromech"
    }
  }
}

```

### variables inside fragments

```
query HeroComparison($first: Int = 3) {
  leftComparison: hero(episode: EMPIRE) {
    ...comparisonFields
  }
  rightComparison: hero(episode: JEDI) {
    ...comparisonFields
  }
}

fragment comparisonFields on Character {
  name
  friendsConnection(first: $first) {
    totalCount
    edges {
      node {
        name
      }
    }
  }
}

```

## Directives

A directive can be attached to a field or fragment inclusion, and can affect execution of the query.

@include(if: Boolean) Only include this field in the result if the argument is true.

@skip(if: Boolean) Skip this field if the argument is true.

```
query Hero($episode: Episode, $withFriends: Boolean!) {
  hero(episode: $episode) {
    name
    friends @include(if: $withFriends) {
      name
    }
  }
}

```

# Mutations

Mutations:

```
mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
  createReview(episode: $ep, review: $review) {
    stars
    commentary
  }
}

```

data:

```
{
  "ep": "JEDI",
  "review": {
    "stars": 5,
    "commentary": "This is a great movie!"
  }
}
```

output: 

```
{
  "data": {
    "createReview": {
      "stars": 5,
      "commentary": "This is a great movie!"
    }
  }
}
```


## Inline Fragments

```
query HeroForEpisode($ep: Episode!) {
  hero(episode: $ep) {
    name
    ... on Droid {
      primaryFunction
    }
    ... on Human {
      height
    }
  }
}
```


In the direct selection, you can only ask for fields that exist on the Character interface, such as name.

To ask for a field on the concrete type, you need to use an inline fragment with a type condition. Because the first fragment is labeled as ... on Droid, the primaryFunction field will only be executed if the Character returned from hero is of the Droid type. Similarly for the height field for the Human type.


## Meta Fields

```
{
  search(text: "an") {
    __typename
    ... on Human {
      name
    }
    ... on Droid {
      name
    }
    ... on Starship {
      name
    }
  }
}

```

output:

```
{
  "data": {
    "search": [
      {
        "__typename": "Human",
        "name": "Han Solo"
      },
      {
        "__typename": "Human",
        "name": "Leia Organa"
      },
      {
        "__typename": "Starship",
        "name": "TIE Advanced x1"
      }
    ]
  }
}

```



# Schemas and Types


## Object Types and Fiels

```
type Character {
  name: String!
  appearsIn: [Episode!]!
}

```
**Arguments**

Every field on a GraphQL object type can have zero or more arguments, for example the length field below:

```
type Starship {
  id: ID!
  name: String!
  length(unit: LengthUnit = METER): Float
}

```

## Scalar Types

GraphQL comes with a set of default scalar types out of the box:

- Int: A signed 32‐bit integer.

- Float: A signed double-precision floating-point value.

- String: A UTF‐8 character sequence.

- Boolean: true or false.

- ID: The ID scalar type represents a unique identifier, often used to refetch an object or as the key for a cache. The ID type is serialized in the same way as a String; however, defining it as an ID signifies that it is not intended to be human‐readable.

In most GraphQL service implementations, there is also a way to specify custom scalar types. For example, we could define a Date type:

`scalar Date`

## Enumeration types


Also called Enums, enumeration types are a special kind of scalar that is restricted to a particular set of allowed values. This allows you to:

1. Validate that any arguments of this type are one of the allowed values
2. Communicate through the type system that a field will always be one of a finite set of values

Here's what an enum definition might look like in the GraphQL schema language:

```
enum Episode {
  NEWHOPE
  EMPIRE
  JEDI
}

```

This means that wherever we use the type `Episode` in our schema, we expect it to be exactly one of `NEWHOPE, EMPIRE, or JEDI.`

## List and Non-Null

```
type Character {
  name: String!
  appearsIn: [Episode]!
}

```

The Non-Null type modifier can also be used when defining arguments for a field,

```
query DroidById($id: ID!) {
  droid(id: $id) {
    name
  }
}

```

data:

```
{
  "id": null
}

```

output:

```
{
  "errors": [
    {
      "message": "Variable \"$id\" of non-null type \"ID!\" must not be null.",
      "locations": [
        {
          "line": 1,
          "column": 17
        }
      ]
    }
  ]
}
```

The Non-Null and List modifiers can be combined. For example, you can have a List of Non-Null Strings:

`myField: [String!]`

This means that the list itself can be null, but it can't have any null members. For example, in JSON:
```
myField: null // valid
myField: [] // valid
myField: ['a', 'b'] // valid
myField: ['a', null, 'b'] // error
```

Now, let's say we defined a Non-Null List of Strings:

`myField: [String]!`

This means that the list itself cannot be null, but it can contain null values:

```
myField: null // error
myField: [] // valid
myField: ['a', 'b'] // valid
myField: ['a', null, 'b'] // valid

```

## Interfaces

An Interface is an abstract type that includes a certain set of fields that a type must include to implement the interface.

```
interface Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
}

```
any type that implements Character needs to have these exact fields, with these arguments and return types.

```
type Human implements Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
  starships: [Starship]
  totalCredits: Int
}
 
type Droid implements Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
  primaryFunction: String
}

```

query:
To ask for a field on a specific object type, you need to use an inline fragment:

```
query HeroForEpisode($ep: Episode!) {
  hero(episode: $ep) {
    name
    ... on Droid {
      primaryFunction
    }
  }
}
```

## Union Types

`union SearchResult = Human | Droid | Starship`

Wherever we return a SearchResult type in our schema, we might get a Human, a Droid, or a Starship.


```
{
  search(text: "an") {
    __typename
    ... on Human {
      name
      height
    }
    ... on Droid {
      name
      primaryFunction
    }
    ... on Starship {
      name
      length
    }
  }
}

```

In this case, if you query a field that returns the SearchResult union type, you need to use an inline fragment to be able to query any fields at all:


input:

```
{
  search(text: "an") {
    __typename
    ... on Human {
      name
      height
    }
    ... on Droid {
      name
      primaryFunction
    }
    ... on Starship {
      name
      length
    }
  }
}
```

output:

```
{
  "data": {
    "search": [
      {
        "__typename": "Human",
        "name": "Han Solo",
        "height": 1.8
      },
      {
        "__typename": "Human",
        "name": "Leia Organa",
        "height": 1.5
      },
      {
        "__typename": "Starship",
        "name": "TIE Advanced x1",
        "length": 9.2
      }
    ]
  }
}
```

## Input Types
Input types look exactly the same as regular object types, but with the keyword input instead of type:

```
input ReviewInput {
  stars: Int!
  commentary: String
}

```

input:


```
mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
  createReview(episode: $ep, review: $review) {
    stars
    commentary
  }
}

```

data:


```
{
  "ep": "JEDI",
  "review": {
    "stars": 5,
    "commentary": "This is a great movie!"
  }
}
```

output:

```
{
  "data": {
    "createReview": {
      "stars": 5,
      "commentary": "This is a great movie!"
    }
  }
}

```

The fields on an input object type can themselves refer to input object types, but you can't mix input and output types in your schema. Input object types also can't have arguments on their fields.

