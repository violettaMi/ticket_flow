# TicketFlow Application

A web-based application to manage and track tickets for various requests, including their excavation details. This application allows users to create and view tickets, including functionality for presenting excavation data on a map.
The application is hosted on render.com: https://ticket-flow-841f.onrender.com/tickets

## Features

- **Create Ticket**: Via  HTTP POST request containing a JSON string once the API is called from outside of the application.
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

### Testing Controllers

#### Testing Ticket Creation (requests/api spec)

Ensure that the `POST /api/tickets` endpoint properly creates a new ticket and a new excavator. In case of missing fields, the controller should return appropriate error messages.

#### Testing Ticket Index (controllers spec)

The `tickets#index` presents a paginated list of tickets. Ensure the order of tickets returned is by creation date (latest first).

#### Testing Ticket Show (controllers spec)

The `tickets#show` presents the details of a specific ticket, including the excavator data and dig site info polygon data within a map.

### Example Tests:

```ruby
RSpec.describe 'Api::TicketsController', type: :request do
  let(:valid_params) do
    {
      RequestNumber: '123456',
      SequenceNumber: '1',
      RequestType: 'Normal',
      DateTimes: {
        ResponseDueDateTime: '2025-01-11T12:00:00Z'
      },
      ServiceArea: {
        PrimaryServiceAreaCode: { SACode: 'ZZGL103' },
        AdditionalServiceAreaCodes: { SACode: [ 'ZZL01', 'ZZL02' ] }
      },
      DigsiteInfo: {
        WellKnownText: 'POLYGON((-81.13390268058475 32.07206917625161, -81.14660562247929 32.04064386441295))'
      },
      Excavator: {
        CompanyName: 'John Doe Construction',
        Address: '123 Main St',
        City: 'Savannah',
        State: 'GA',
        Zip: '31401',
        CrewOnsite: 'true'
      }
    }
  end
  
  describe 'POST /api/tickets' do
    context 'with valid parameters' do
      it 'creates a ticket and returns ticket_id' do
        post '/api/tickets', params: valid_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json).to include('ticket_id')
      end
    end
  end
end
