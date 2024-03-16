# driversbuddy

Mam plan

Serwis w Azure z cenami na stacjach w polsce (rózne zrodła danych np ceny hurtowe, ceny sprzedazy u dostawcow kart itd)
Aplikacja mobilna iOS na iPhone, iPad, wyswietla ceny na stacjach w promieniu okreslonej liczby kilometrow.
Mozna odfiltrować stacje na dowolny koncern
filtrowac stacje wg uslug, czy ma ladowarki, prysznic, sklep ,itd
Kalkulator kosztu przejazdu trasami z uwzglednieniem cen, z optymalizatorem, gdzie warto zatankowac, aby trasa wyszla najtaniej.

Rejestr pojazdów
rejestrowanie tras np dla potrzeba rozliczania z urzędem skarbowym
rejestrowanie zakupów
import danych z transakcjami shell/orlen/bp inne ..

rozpoznawanie kodu Aztec z dowodu rejestracyjnego
rozpoznawanie paragonów i faktur zakupowych

wykorzystane technologie serwis c# + ms sql (ewentualnie vapor + postgres)
swiftUI, Swift SwiftData



## Model SwiftData

```mermaid
classDiagram


  class VehicleElement {
    vehicle: VehicleVehicle
    events: EventElement[]
    customItems: CustomItem[]
    shops: Shop[]
  }

  class CustomItem {
    department: Department
    wearType: Int
    uuid: String
    id: Double
    eventType: Int
    name: String
  }

  class Department {
    nameDe: String
    eventType: Int
    namePl: String
    iconName: String
    nameUk: String
    name: String
    id: Int
  }

  class EventElement {
    items: Item[]
    event: EventEvent
    odometer: Odometer
    fuelUp: FuelUp
    shopID: Shop
    fuelBrand: FuelBrand
    vehicle: VehicleVehicle
  }

  class EventEvent {
    uuid: String
    notes: String
    type: Int
    date: Double
    diy: Bool
    paymentMethod: Int
    cost: Double
     vehicle: VehicleVehicle
  }

  class FuelBrand {
    name: String
    uuid: String
  }

  class FuelUp {
    partial: Bool
    rebate: Int
    cityPercentage: Int
    quantity: Double
    uuid: String
    reset: Bool
    pricePerVol: Double
    octane: String
     vehicle: VehicleVehicle
  }

  class Item {
    notifiedOn: Int
    maintenanceID: Double
    interval: Int
    notifiedAt: Int
    intervalMonths: Int
    uuid: String
  }

  class Odometer {
    uuid: String
    reading: Int
    date: Double
    units: Int
    vehicle: VehicleVehicle
  }

  class Shop {
    website: String
    postalCode: String
    contact: String
    state: String
    country: String
    name: String
    addr1: String
    addr2: String
    uuid: String
    image: String
    email: String
    city: String
    phone: String
  }

  class VehicleVehicle {
    pressureUnits: Int
    plate: String
    consumptionUnits: Int
    year: Int
    tpFront: Int
    trim: String
    creationDate: Double
    name: String
    units: Int
    insurance: String
    type: Int
    tpRear: Int
    status: Int
    fuelUnits: Int
    make: String
    uuid: String
    model: String
    vin: String
    fuelType: Int
    notes: String
    registration: String
  }


```







## Postepy w Interfejsie



![image-20240302230036196](image-20240302230036196.png)





Vehicle inspection screen:

![image-20240314122519369](image-20240314122519369.png)





Możliwość dodawania opisów uszkodzeń

**Rysy** na karoserii pojazdu to jak tajemnice wypisane na pergaminie metalu. Każda z nich ma swoją historię, jak wiersz napisany przez wiatr i piasek. Oto opowieść o tych drobnych bliznach:

1. **Rysa Świtu**: Na masce, tuż przy logo, widnieje cienka rysa. To jak pierwszy promień słońca, który przecina noc. Ktoś, może zakochany, może zbyt pochopny, zostawił tu ślad swojego przejścia.
2. **Rysa Wiatru**: Na dachu, tam gdzie powietrze tańczy z prędkością, jest rysa. To jak nuta na partyturze, zapisana przez wiatr. Może to moment, gdy samochód przemierzał bezdroża, a wiatr śpiewał mu piosenkę o wolności.
3. **Rysa Deszczu**: Na błotniku, blisko kół, widnieje rysa. To jak łza spadająca z nieba, kiedy deszcz płakał nad miastem. Może to chwila, gdy auto przemierzało mokre ulice, a deszcz tulił je do snu.
4. **Rysa Nocy**: Na drzwiach, przy klamce, jest rysa. To jak cień, który przeszedł przez noc. Może to moment, gdy samochód stał pod gwiazdami, a noc była jego jedynym towarzyszem.

![](image-20240314122620711.png)

oraz zdjęć tych uszkodzeń

![image-20240315092045167](image-20240315092045167.png)
