# Tytuł zadania

Automatyzacja Azure przez Powershell.

---

## Opis

Zadanie polegało na opracowaniu skryptu w środowisku Powershell, umoliwiającego utworzenie zasobu Azure Storage Account bez konieczności interaktywnego logowania w przeglądarce, realizując ten proces za pomocą parametrów dedykowanego konta technicznego Service Principal.

---

## Wymagania

- Powershell 7+
- Moduł Az PowerShell
- Tożsamość Service Principal, pozwalająca na nadanie uprawnień dla danej zarejestrowanej aplikacji w celu uzyskania dostępu do pewnych zasobów Azure'a
- Skonfigurowane zmienne środowiskowe, przechowujące parametry Service Principal

---

## Zmienne środowiskowe

W celu uwierzytelnienia do platformy Azure z poziomu Powershella wymagane są trzy parametry tożsamości Service Principle: client_id, tenant_id oraz client_secret. Wartości tych parametrów, w szczególności client_secret, muszą być przechowywane w bezpiecznym miejscu. Na potrzeby zadania zdecydowano się przechowywać te wartości lokalnie jako zmienne środowiskowe systemu, które należało ustawić przed uruchomieniem skryptu:

| Zmienna               | Opis                                                                                                  |
| --------------------- | ----------------------------------------------------------------------------------------------------- |
| `AZURE_CLIENT_ID`     | Zawiera klucz ID, który można traktować jako username tej tożsamości aplikacji                        |
| `AZURE_TENANT_ID`     | Klucz ID, który mówi, do jakiej organizacji należy ta Service Principle                               |
| `AZURE_CLIENT_SECRET` | Ciąg znaków, który jest hasłem do uwierzytelnienia podczas żądania przez aplikację tokenu dostępowego |

---

## Jak uruchomić

```powershell
cd /XXX/YYY
./auth_script.ps1
```

## Jak działa

1. Skrypt odczytuje wartości zmiennych środowiskowych (parametrów Service Principal) i przypisuje je do zmiennych Powershell
2. Następuje konwersja clientSecret do typu Secured String, przez co clientSecret zostaje zaszyfrowane w pamięci (zwykły string nie jest akceptowany przez .PSCredential)
3. Tworzony jest obiekt credentials, składający się z clientId i secureSecret
4. Uwierzytelnianie do Azure'a za pomocą polecenia Connect-AzAccount z flagą Service Principal i jej wymaganymi parametrami
5. Następnie zdefiniowane są trzy zmienne będące core parametrami odnośnie zasobów, czyli nazwa dedykowanej Resource group, nazwa zasobu Storage Account i location
6. Polecenie Get-AzResourceGroup sprawdza, czy istnieje dana grupa zasobów. Jeśli tak to jest ona zwracana, jeśli nie to działanie skryptu zostaje przerwane
7. New-AzStorageAccount tworzy wymagany zasób Storage account w danej resource groupie, gdzie dodatkowymi prametrami są SkuName (gdzie przechowywane są dane znajdujące sie w Storage account i ile kopii danych zostaje utworzone; Standard - dysk HDD, LRS - 3 kopie, wszystkie w jednym centrum danych) oraz Kind (StorageV2 - wspiera wszystkie typy danych i funkcje)
8. Utworzony zasób jest zwracany i przypisany do zmiennej storage, a we wierszu poleceń wyświetlane jest potwierdzenie ukończenia całego procesu

## Test

Skrypt poprawnie tworzy Storage Account w dedykowanej resource groupie, co prezentują zrzuty ekranu z oknem wiersza poleceń oraz z samej platformy Azure. Możliwym problemem w działaniu skryptu może być nazwa Storage Account - musi być ona globalnie unikatowa dla całego Azure'a.

![alt text](image.png)
![alt text](image-1.png)
![alt text](image-2.png)
