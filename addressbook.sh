#!/bin/bash

# Address Book Shell Script by Bilal Aksoy and Can Parlayan

cancel_key=1        # Variable that we will proccess if user pressses the cancel or return to menu buttons
escape_key=255      # Variable that we will proccess if user presses esc on their keyboard

importVar=false

addRecord() {
	dialog --msgbox "To add to the address book, please enter the information in the order of 'name,surname,phone number,e-mail' without any spaces and commas in between." 8 60 --stdout 
	dialog --msgbox "For example: 'Bilal,Aksoy,05543794066,bilal.aksoy@std.ieu.edu.tr'\n'Can,Parlayan,05068372123,can.parlayan@std.ieu.edu.tr'" 8 60 --stdout

while true
do
	addInput=$(dialog --cancel-label "Return to menu" \--inputbox "Please enter the informations as previously mentioned: " 8 60 --stdout)
	
	if [ $? == "$cancel_key" ]  # $? control operator is used to check the status of last executed command
	then
	break
	elif ! [ -z "${addInput}" ] # We are checking the if the addInput variable is null or not
	then
	echo $addInput >> addressbook.csv	# We are redirecting the contents of addInput into addressbook.csv
	dialog --msgbox "The record has been added to address book!" 8 60 --stdout
	else
	dialog --msgbox "Please enter a valid input!" 8 60 --stdout
	addRecord
	fi
	menu	
done
	
	}

displayRecord() {
        displayInfo=$(cat < addressbook.csv)     # We read the contents of addressbook.csv and store them inside displayInfo
        if [ "$(wc -l <addressbook.csv)" -eq 0 ]         # We are checking if the first line at the addressbook.csv has the word line count of 0
	then
        dialog --msgbox "No record has been found!" 8 60 --stdout
        else
        dialog --msgbox "$displayInfo" 8 60 --stdout   
        fi
      menu
}

searchRecord() {

	while true
	do
		searchInput=$(dialog --cancel-label "Return to menu" \--inputbox "Please enter any string to search record: " 8 60 --stdout)
		     # grep is used here to search through addressbook.csv to find the string user entered which is stored as searchInput
	
	                                                                 
	if [ $? == "$cancel_key" ]    # $? control operator is used to check the status of last executed command
	then
	break
	else
	 searchResult=$(grep -i "$searchInput" addressbook.csv)      # grep is used here to search through addressbook.csv to find the string user entered which is stored as searchResult
	 if [ -z $searchInput ]
	 then
	 dialog --msgbox "Please enter a valid input" 8 60 --stdout
	 searchRecord
	 elif ! grep -i "$searchInput" addressbook.csv   
	 then
	 dialog --msgbox "No match!" 8 60 --stdout
	 elif grep -i "$searchInput" addressbook.csv # If grep finds the searchInput's value inside addressbook.csv
	 then
	 dialog --msgbox "$searchResult" 8 60 --stdout
	 fi
	fi
	menu
	done		
	
}

updateRecord()
{
	while true
	do
		updateInput=$(dialog --cancel-label "Return to menu" --inputbox "Please enter any string to update record: (Case-sensitive)" 8 60 --stdout)
		
	 
		
		if [ $? == "$cancel_key" ]    # $? control operator is used to check the status of last executed command
	        then
	        break
	        else
	        listingResult=$(grep -i "$updateInput" addressbook.csv)  # grep is used here to search through addressbook.csv to find the string user entered which is stored as updateInput
	         if [ -z $updateInput ]
	         then
	         dialog --msgbox "Please enter a valid input" 8 60 --stdout
	         updateRecord
	         elif [ -z $listingResult ]      
	         then
	         dialog --msgbox "No match!" 8 60 --stdout
	         elif ! grep -i "$listingResult" addressbook.csv
	         then
	         dialog --msgbox "No match!" 8 60 --stdout
	         elif grep -i "$listingResult" addressbook.csv # If addressbook.csv contains the listingResult variable's content 
	         then
	         listingResultwLine=$(grep -ni "$updateInput" addressbook.csv) # Searches the updateInput without case sensitivity and with adding a line number starting from 1 inside
	         dialog --msgbox "Listing records for \"$updateInput\" : \"$listingResultwLine\""  8 60 --stdout
		 lineNumber=$(dialog --inputbox "Enter the line number to update that line: " 8 60 --stdout)
		 for line in `grep -n "$updateInput" addressbook.csv` # Searches the uptadeInput for each line
		   do
			number=`echo "$line" | cut -c1` # echo $line == call the line //// cut -c1 select characters from input line 1
			if [ $number -eq $lineNumber ]
				then
				update=$(dialog --inputbox "Please enter the informations as 'name,surname,phone number,e-mail'" 8 60 --stdout)
				lineUpdate="${lineNumber}s" # s : if lineNumber is replaced it will empty the variable
				if [ -z $update ]
				then
				dialog --msgbox "Enter a valid input!" 8 60 --stdout
				else
				sed -i "$lineUpdate/.*/$update/" addressbook.csv  # .* is a regex that matches a whole single line
				dialog --msgbox "Update has been done!" 8 60 --stdout
				fi
				menu
			else 
			    dialog --msgbox "Not a valid line!" 8 60 --stdout	
			fi
		   done
		 fi
	     
	        fi
	   menu
	done	  
}

quit(){   # It mercilessly kills all the processes. If you have multiple tabs opened it will close the others too.
PPPID=$(awk '{print $4}' "/proc/$PPID/stat") # {print $4}'indicates that the fourth field should be printed. The PPID is the parent process id, in this instance the shell. The PPPID is the parent process id of PPID, in this example the terminal window ////  awk gets the value of the fourth column of the file and returns 0) 
kill $PPPID  # Kills the proccess according to the PPPID variable 
}

deleteRecord()
{
	while true
	do
		deleteInput=$(dialog --cancel-label "Return to menu" --inputbox "Please enter any string to delete a record:(Case-sensitive)"  8 60 --stdout)
		
	 
		
		if [ $? == "$cancel_key" ]    
	        then
	        break
	        else
	        listingResult=$(grep -i "$deleteInput" addressbook.csv)  # grep is used here to search through addressbook.csv to find the string user entered without case sensitivity which is stored as deleteInput
	         if [ -z $deleteInput ]
	         then
	         dialog --msgbox "Please enter a valid input" 8 60 --stdout
	         deleteRecord
	         elif [ -z $listingResult ]      
	         then
	         dialog --msgbox "No match!" 8 60 --stdout
	         elif grep -i "$listingResult" addressbook.csv # If addressbook.csv contains the listingResult variable's content 
	         then
	         listingResultwLine=$(grep -ni "$deleteInput" addressbook.csv)   # Searches the deleteInput without case sensitivity and with adding a line number starting from 1 inside addressbook.csv   
	         dialog --msgbox "Listing records for \"$deleteInput\" : \"$listingResultwLine\""  8 60 --stdout
		 lineNumber=$(dialog --inputbox "Enter the line number to delete that line: " 8 60 --stdout)
		  if [ -z $lineNumber ]
			then
			dialog --msgbox "Enter a valid input!" 8 60 --stdout 
		  else		
		       for line in `grep -n "$deleteInput" addressbook.csv`
		         do
			 number=`echo "$line" | cut -c1`  
			 if [ $number -eq $lineNumber ]
			    then
			    lineDelete="${lineNumber}d" # d will delete the line of variable lineNumber if a deletion occurs
			    sed -i "$lineDelete" addressbook.csv       # sed here changes the line we get earlier and deletes the line according to the lineNumber variable
			    dialog --msgbox "Deletion has been done!" 8 60 --stdout
			 else 
			    dialog --msgbox "Not a valid line!" 8 60 --stdout
			 fi
			    menu
			 done	
		  fi
		   
		 fi
	     
	        fi
	   menu
	done	  
}
import(){
if [ $importVar == true ] # Disables second import process
then
	dialog --msgbox "You've already imported!" 8 60 --stdout
else
while true
	do
	importInput=$(dialog --cancel-label "Return to menu" --inputbox "Please enter the name of .csv file you want to import: (For example : book.csv)"  8 60 --stdout)
	if [ $? == "$cancel_key" ]    
	  then
	  break
	elif [ -z $importInput ]
	then
	dialog --msgbox "Please enter a valid input!" 8 60 --stdout
	else
           file=$(cat $importInput)
           if [ ! -f $importInput ] # Checks is file exists
           then
           dialog --msgbox "File doesn't exist!" 8 60 --stdout
           else
           dialog --msgbox "Imported successfully!" 8 60 --stdout
           for line in $file
           do
           echo -e "$line" >> addressbook.csv
           done
	   importVar=true
           fi
         fi 
         menu  
        done
fi
}


menu(){
while true
do
 exec 3>&1 # The 3>&1 in your command line will create a new file descriptor and redirect it to 1 which is STDOUT
 selection=$(dialog \
   --backtitle "BC's Adress Book" \
   --title "Menu" \
   --clear \
   --no-cancel \
   --menu "Choose: " 15 50 10 \
   "1" "Add a new record to the address book." \
   "2" "Display the address book records." \
   "3" "Search a record from the address book." \
   "4" "Update a record from the address book." \
   "5" "Delete a record from the address book." \
   "6" "Import." \
   "7" "Quit." \
2>&1 1>&3) # 2>&1 means that stderr is redirected to stdout /// and 2>&3 will redirect file descriptor 2 to 3 which is STDOUT
exit_status=$?
 exec 3>&- # 3>&- means that file descriptor 3, opened for writing(same as stdout), is closed
 case $exit_status in 
 $cancel_key)   # If the exit status equals cancelKey
     clear 
     echo "Command line terminated."
     exit
     ;;
   $escape_key) # If the exit status equals escapeKey
     clear
     echo "Program stopped unexpectedly." >&2 # We are using this here to send the output to standard error instead of standard out
     exit 1
     ;;
 esac
 case $selection in
   0 )
      clear
      echo "Have a nice day!"
      ;;
   1 )var=addRecord      
   addRecord "Add Record";;
   2 )var=displayRecord
   displayRecord "Display Record";;
   3 )var=searchRecord
   searchRecord "Search Record";;
   4 )var=updateRecord
   updateRecord "Update Record";;
   5) var=deleteRecord
   deleteRecord "Delete Record";;
   6) var=import
   import "Import";;
   7) var=quit
   quit "Quit";;
esac
done
}
dialog --msgbox "Welcome to the BC's Address Book!" 8 60  --stdout
dialog --msgbox "Which operation would you like to do with address book? Press OK, then select." 8 60 --stdout
menu

