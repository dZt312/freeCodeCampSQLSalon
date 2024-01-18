#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
 if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
echo -e "\nWelcome to My Salon, how can I help you?"
echo -e "\n1) Haircut\n2) Hair Color\n3) Waxing"

read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
  1) SERVICE_MENU ;;
  2) SERVICE_MENU ;;
  3) SERVICE_MENU ;;
  *) MAIN_MENU "We don't have that service" ;;
esac
}

SERVICE_MENU() {
  SERVICE_ID=$($PSQL "SELECT service_id from services WHERE service_id = '$SERVICE_ID_SELECTED'")
  #get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  #if not found
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  #get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  #insert appointment
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")
  echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
  echo -e "I have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
}
MAIN_MENU