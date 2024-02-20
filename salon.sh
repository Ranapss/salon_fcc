#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"


MAIN_MENU(){

echo -e "\nThank you for choosing The Salon, here are the available services:"
SERVICES=$($PSQL "SELECT * FROM services")
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
do
echo "$SERVICE_ID) $SERVICE_NAME"
done
echo -e "\nPlease select a servivce."
read SERVICE_ID_SELECTED
if [[  ! $SERVICE_ID_SELECTED =~ ^[0-9]+$  ]]
then
echo -e "\nPlease enter a valid number, no letters."
MAIN_MENU
else
SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SELECTED_SERVICE_NAME ]]
then
echo -e "\nPlease enter a valid number."
MAIN_MENU
else
# get phone number
echo -e "\nPlease enter your phone number."
read CUSTOMER_PHONE
# check if number in table and if not get name and add to customers
#CUSTOMER_ID=$(CHECK_PHONE $CUSTOMER_PHONE)

  PHONE_CHECK_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $PHONE_CHECK_RESULT ]]
  then 
    echo -e "\nYou're not in our database, please enter your name."
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  else
    CUSTOMER_ID=$PHONE_CHECK_RESULT
  fi  

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
# else get appt time and add to appts
echo -e "\nWhat time would you like your appointment?"
read  SERVICE_TIME

INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (service_id,customer_id,time) VALUES ($SERVICE_ID_SELECTED,$CUSTOMER_ID,'$SERVICE_TIME')") 

# out put message with information 
echo -e "\nI have put you down for a$SELECTED_SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
fi
fi

}

CHECK_PHONE(){
  PHONE_CHECK_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$1'")
  if [[ -z $PHONE_CHECK_RESULT ]]
  then 
    echo -e "\nYou're not in our database, please enter your name."
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$1')")
    echo $($PSQL "SELECT customer_id FROM customers WHERE phone='$1'")
  else
    echo $PHONE_CHECK_RESULT
  fi  
}


MAIN_MENU
