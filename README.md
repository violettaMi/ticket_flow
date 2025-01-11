# TicketFlow Application

A web-based application to manage and track tickets for various requests, including their excavation details. This application allows users to create and view tickets, including functionality for presenting excavation data on a map.

## Features

- **Create Ticket**: Submit a new ticket with required fields.
- **View Tickets**: Retrieve a list of tickets and view detailed information within excavator data.
- **View Ticket**: Retrieve an individual ticket within excavation map.
- **Pagination**: Paginate the list of tickets to improve browsing experience.
- **Validation**: Ensure that tickets cannot be created with missing required fields.

## Technologies

- **Ruby on Rails**: Backend framework.
- **PostgreSQL**: Database for storing tickets and excavation information.
- **RSpec**: Testing framework.
- **FactoryBot**: For generating test data in RSpec tests.

## Getting Started

### Prerequisites

To run this application locally, you will need the following:

- **Ruby**: Version 3.2.2
- **Rails**: Version 7.2.2.1
- **PostgreSQL**: Version 14.13.
- **Node.js** (for managing JavaScript assets).
- **Yarn** (for managing front-end dependencies).

### Installation

1. Clone this repository:
    ```bash
    git clone https://github.com/violettaMi/ticket_flow
    cd ticket_flow
    ```

2. Install Ruby dependencies:
    ```bash
    bundle install
    ```

3. Install JavaScript dependencies:
    ```bash
    yarn install
    ```

4. Set up the database:
    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

5. Precompile Assets:
    ```bash
    rails assets:precompile
    ```
    
6. Start the Rails server:
    ```bash
    rails server
    ```

### API Endpoints

The application exposes the following API endpoints:

#### `POST /api/tickets`

- **Description**: Create a new ticket with excavation information.
- **Request**: The request body should contain the following attributes for both the ticket and excavation details.
- **Example Request**:
```json
 {
  "request_number": "09252012-00001",
  "request_type": "Normal",
  "sequence_number": 2421,
  "response_time": "2025-01-12T09:00:00",
  "primary_service_area_code": "SA001",
  "additional_service_area_codes": ["SA002", "SA003"],
  "dig_site_info": "POLYGON((30.1 10.1, 40.2 20.2, 20.3 30.3, 10.4 40.4, 30.1 10.1))",
  "excavator": {
    "company_name": "Excavator Co.",
    "address": "123 Excavation St., Digville, DX",
    "crew_on_site": true
    }
  }
```

#### `GET /tickets`

- **Description**: Retrieve a list of tickets.
- **Query Parameters**:
  - `page`: (integer) The page number for pagination (optional, defaults to 1).
- **Response**:
  - **Success (200)**:
    ```json
    [
      {
        "id": 1234,
        "request_number": "09252012-00001",
        "request_type": "Normal",
        "created_at": "2025-01-11T13:21:42.000Z",
        "excavator": {
          "company_name": "Excavator 1",
          "ticket_id": 1234
        }
      },
      ...
    ]
    ```

#### `GET /tickets/:id`

- **Description**: View details of a specific ticket.
- **Request**:
  - `id`: The unique identifier of the ticket.
- **Response**:
  - **Success (200)**:
    ```json
    {
      "id": 1234,
      "request_number": "09252012-00001",
      "sequence_number": 2421,
      "request_type": "Normal",
      "excavator": {
        "id": 5678,
        "name": "Excavator 1",
        "ticket_id": 1234
      },
      "dig_site_info": "POLYGON((30.1 10.1, 40.2 20.2, 20.3 30.3, 10.4 40.4, 30.1 10.1))",
      "created_at": "2025-01-11T13:21:42.000Z",
      "updated_at": "2025-01-11T13:21:42.000Z"
    }
    ```
  - **Failure (404)**: If the ticket does not exist:
    ```json
    {
      "errors": ["Ticket not found"]
    }
    ```

## Testing

The application uses **RSpec** for testing. Follow the steps below to run tests:

1. Install required gems:
    ```bash
    bundle install
    ```

2. Run the tests:
    ```bash
    bundle exec rspec
    ```

### Testing TicketsController

#### Testing Ticket Creation

Ensure that the `POST /api/tickets` endpoint properly creates a new ticket and a new excavator. In case of missing fields, the controller should return appropriate error messages.

#### Testing Ticket Index

The `GET /tickets` should return a paginated list of tickets. Ensure the order of tickets returned is by creation date (latest first).

#### Testing Ticket Show

The `GET /tickets/:id` should return the details of a specific ticket, including the excavator and dig site info.

### Example Tests:

```ruby
RSpec.describe TicketsController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new ticket' do
        valid_params = { request_number: '1234', request_type: 'Normal', dig_site_info: 'POLYGON((...))' }
        post :create, params: valid_params, as: :json

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['ticket_id']).to be_present
      end
    end
  end
end
