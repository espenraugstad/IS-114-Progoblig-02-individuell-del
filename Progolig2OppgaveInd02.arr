use context essentials2021
include gdrive-sheets
#Pakken dcic-2021
include shared-gdrive("dcic-2021","1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")
include data-source
ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
kWh-wealthy-consumer-data =
  load-table: komponent, energi
    source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
      # Oppgave a)
    sanitize energi using string-sanitizer
end

# Funksjonen for å beregne forbruket fra bil
fun car-energy(distance :: Number, distance-per-unit-fuel :: Number) -> Number:
  energy-per-unit-fuel = 10 # Konstant verdi hentet fra forelesningsnotatene
  (distance / distance-per-unit-fuel) * energy-per-unit-fuel
end

fun energi-to-number(str :: String) -> Number:
  #Oppgave b)
  # skriv koden her (tips: bruk cases og string-to-number funksjonen)
  cases(Option) string-to-number(str):
    | some(a) => a
      # Original case
      # | none => 0
      
      # Modifisert case
     | none => car-energy(50,12)
  end
where:
  # Den første testen feiler etter å ha modifisert case
  # energi-to-number("") is 0
  energi-to-number("") is car-energy(50,12)
  energi-to-number("48") is 48
end

# Fjern kommentar på neste linje for å se tabellen før transformasjon.
# kWh-wealthy-consumer-data

transformed-kWh-wealthy-consumer-data = transform-column(kWh-wealthy-consumer-data, "energi", energi-to-number)
transformed-kWh-wealthy-consumer-data

# Oppgave d) Totalt energiforbruk inkludert forbruket fra bil.
energy-consumption = sum(transformed-kWh-wealthy-consumer-data, "energi") + car-energy(50, 12)
# Vis resultatet i interaksjonsvinduet
energy-consumption

# Oppgave e) Visualisering av dataene
bar-chart(transformed-kWh-wealthy-consumer-data, "komponent", "energi")

# Se funksjonen energi-to-number på linje 20 for å se endringene som er gjort for å få verdien for energiforbruket til en bil inn i tabellen.